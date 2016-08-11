module JquestPg
  class Mandature < ActiveRecord::Base
    MAX_ASSIGNABLE = 6.freeze
    # Add a filter method to the scope
    include Filterable
    include CsvAttributes

    has_paper_trail :on => [:update]
    belongs_to :legislature
    belongs_to :person
    has_many :sources, foreign_key: :resource_id, :dependent => :delete_all
    has_many :assignments, foreign_key: :resource_id, :dependent => :delete_all
    after_update :track_activities

    validates :person, presence: true
    validates :legislature, presence: true

    def self.csv_attributes
      %w{id legislature person political_leaning role group area chamber}
    end

    def name
      if person
        "Term of #{person.fullname} in #{legislature.name}"
      else
        id
      end
    end

    def track_activities
      # Find the last version of this model
      uid = versions.last.nil? ? nil : versions.last.whodunnit
      # This someone must exist!
      return if uid.nil?
      # Find the user
      user = User.find uid
      # Find assignment for this user...
      assignment = Assignment.where(user: user, resource: self).first
      # Attributes that might changed
      [:role, :political_leaning].each do |n|
        # Did it changed?
        if method("#{n}_changed?").call and not read_attribute(n).blank?
          # And save the activity
          Activity.find_or_create_by user: user, taxonomy: 'details', value: n,
                                     points: 2, assignment: assignment, resource: self
        end
      end
    end

    def fields_required
      [:role, :political_leaning]
    end

    def fields_completed
      fields_required.reduce 0 do |memo, field|
        memo + ( read_attribute(field).blank? ? 0 : 1 )
      end
    end

    def completion
      # Field to complete
      ll = person.fields_required.length + fields_required.length
      # Field completed
      cc = person.fields_completed + fields_completed
      # Return the percentage of completed field
      100.0 * cc / ll
    end

    def assigned_to?(user)
      user.assignments.exists?(resource: self)
    end

    def restore!
      # Does the version exist?
      unless versions.first.nil?
        versions.first.reify.save!
      end
      # Does the version for the related person exist?
      unless person.nil? or person.versions.first.nil?
        person.versions.first.reify.save!
      end
    end

    def self.some_are_assigned_to?(user, season=user.member_of)
      self.assigned_to(user, season, true).length > 0
    end

    def self.assign_to!(user, season=user.member_of)
      # A array of assigned mandature
      assigned_mandatures = []
      # Get the list of legislatures that can be assigned to the user
      assignable_legislatures = Legislature.assignable_to user
      # Stop here if no mandatures is assignable
      return assigned_mandatures if assignable_legislatures.length == 0
      # Number of mandature picked from each legislatures depends of the number of legislature
      per_legislatures = [(MAX_ASSIGNABLE.to_f / assignable_legislatures.length).ceil, 1].max
      # For each legislature...
      assignable_legislatures.each do |legislature|
        # Pick enough mandature!
        per_legislatures.times.each do
          # Attempts available to find a mandature (no more than 10)
          10.times.each do
            # Rick a random mandature not already assigned
            mandature = legislature.mandatures.where.not(id: assigned_mandatures).order("RANDOM()").first
            # Ensure no one else is assigned to that mandature
            if not mandature.nil? and not Assignment.exists? resource: mandature
              assigned_mandatures << mandature
              break
            end
          end
        end
      end
      # Insert within a transaction
      Assignment.transaction do
        # Maximum number of person to assign
        max = [0, MAX_ASSIGNABLE - user.assignments.pending.count() ].max
        # Ensure we haven't een too greedy
        assigned_mandatures = assigned_mandatures.slice 0, max
        # Now our assigned mandatures list must be populated, it is time to save it
        # as assignments for the given user.
        assigned_mandatures.each do |mandature|
          Assignment.create! user: user, resource: mandature, season: season
        end
      end
      # Returns the mandatures
      assigned_mandatures
    end

    def self.assigned_to(user, season=user.member_of, force=true, status=nil)
      # All user assignments
      assignments = user.assignments
      # According to status
      assignments = assignments.where(status: status) unless status.nil?
      # Get all assignments status
      ids = assignments.where(resource_type: Mandature).map(&:resource_id)
      # The user may not have assigned mandature yet
      if not ids.nil? and ids.length > 0
        # Collect mandatures assigned to that user
        where id: ids
      elsif force
        # Assign mandature to the user
        Mandature.assign_to! user, season
        # Recursive call, without forcing assignments this time
        assigned_to user, season, false, status
      else
        # None assigned
        none
      end
    end

    def self.unassigned_to(user, season=user.member_of, force=true, status=nil)
      # Ids of the mandatures assigned to that user
      mids = Mandature.assigned_to(user, season, force, status).map(&:id)
      # Mandatures not assigned to that user
      Mandature.where.not(id: mids)
    end
  end
end
