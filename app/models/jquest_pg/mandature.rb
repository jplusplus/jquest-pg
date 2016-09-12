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
      assignment = as_assignment_for user
      # Attributes that might changed
      fields_required_changed.each do |field|
        # And save the activity
        Activity.find_or_create_by user: user, taxonomy: 'details', value: field,
                                   points: 200, assignment: assignment, resource: self
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

    def fields_required_changed
      fields_required.select do |field|
        method("#{field}_changed?").call and not read_attribute(field).blank?
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

    def pending_and_assigned_to?(user)
      user.assignments.pending.exists?(resource: self)
    end

    def skipped_by(user)
      # And save the activity
      Activity.find_or_create_by user: user, taxonomy: 'details', value: 'skipped',
                                 points: -250, resource: self,
                                 assignment: as_assignment_for(user)
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

    def age
      person.age legislature.start_date
    end

    def age_range
      if not age.present?
        nil
      elsif age < 30
        'bellow-30'
      elsif age >= 70
        'over-70'
      else
        "#{age - age%10}-#{age - age%10 + 10}"
      end
    end

    def as_assignment_for(user)
      Assignment.find_by user: user, resource: self
    end

    def self.count_by(path)
      # Group by path
      scope = self.all.to_a.group_by do |mandature|
        # Split on '.' and itteraye over keys
        path.split(".").inject(mandature) do |hash, key|
          unless hash.nil?
            hash.method(key).call
          end
        end
      end
      # Count items
      scope.map { |k,v| [k, v.length] }.to_h.select { |key| key.present? }
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
      # Ensure we haven't een too greedy
      assigned_mandatures = assigned_mandatures.slice 0, MAX_ASSIGNABLE
      # Now our assigned mandatures list must be populated, it is time to save it
      # as assignments for the given user.
      assigned_mandatures.each do |mandature|
        # Create an assignment (may fail)
        Assignment.create user: user, resource: mandature, season: season
      end
      # Returns the mandatures
      assigned_mandatures
    end

    def self.missing_assignments(user, season, level=nil)
      # Get level if unspecified
      level ||= user.points.find_or_create_by(season: season).level
      # Return the uncached result of the count query
      uncached do
        MAX_ASSIGNABLE - user.assignments.where(level: level, season: season).count()
      end
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

    def self.updated_through_people
      joins('INNER JOIN jquest_pg_people ON jquest_pg_people.id = jquest_pg_mandatures.person_id').
      joins("INNER JOIN versions ON versions.item_id = jquest_pg_people.id AND versions.item_type = 'JquestPg::Person'").
      where('versions.event = ? ', 'update')
    end

    def self.unfinished
      Rails.cache.fetch("pg/mandatures/unfinished", expires_in: 60.minutes) do
        # Join to related tables
        eager_load(:person).
        eager_load(:legislature).
        # Only current legislature
        where('jquest_pg_legislatures.end_date > ?', Time.now)
      end
    end
  end
end
