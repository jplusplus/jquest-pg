module JquestPg
  class Mandature < ActiveRecord::Base
    # Add a filter method to the scope
    include Filterable

    has_paper_trail
    belongs_to :legislature
    belongs_to :person
    has_many :sources, foreign_key: :resource_id
    has_many :assignments, foreign_key: :resource_id
    after_update :track_activities

    def self.legislature(id)
      where 'legislature_id = ?', id.to_i
    end

    def self.legislature__country(code)
      joins(:legislature).where 'jquest_pg_legislatures.country = ?', code
    end

    def self.legislature__territory(territory)
      joins(:legislature).where 'jquest_pg_legislatures.territory = ?', territory
    end

    def to_s
      "#{person.fullname} in #{legislature.name}"
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
      # Get user progression
      progression = JquestPg::ApplicationController.new.progression user
      # ROUND 2
      # Multiple value may have changed
      if progression.round == 2
        # Attributes that might changed
        [:role, :political_leaning].each do |n|
          # Did it changed?
          if method("#{n}_changed?").call
            # And save the activity
            Activity.find_or_create_by user: user, taxonomy: 'details', value: n,
                                       points: 2, assignment: assignment, resource: self
          end
        end
      end
    end

    def legislature_fields_required
      [:role, :political_leaning, :name]
    end

    def legislature_fields_completed
      legislature_fields_required.reduce 0 do |memo, field|
        memo + ( legislature[field].blank? ? 0 : 1 )
      end
    end

    def person_fields_required
      [:birthdate, :birthplace, :education, :profession_category, :gender, :image]
    end

    def person_fields_completed
      person_fields_required.reduce 0 do |memo, field|
        memo + ( person[field].blank? ? 0 : 1 )
      end
    end

    def completion
      # Field to complete
      ll = person_fields_required.length + legislature_fields_required.length
      # Field completed
      cc = person_fields_completed + legislature_fields_completed
      # Return the percentage of completed field
      100.0 * cc / ll
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
      per_legislatures = [(6.0 / assignable_legislatures.length).ceil, 1].max
      # For each legislature...
      assignable_legislatures.each do |legislature|
        # Pick enough mandature!
        per_legislatures.times.each do
          mandature = nil
          # Attempts available to find a mandature (no more than 10)
          attempts = 10
          loop do
            # Rick a random mandature not already assigned
            mandature = legislature.mandatures.where.not(id: assigned_mandatures).order("RANDOM()").first
            # Ensure no one else is assigned to that mandature
            already_assigned = Assignment.exists? resource: mandature
            # Save the attempt
            attempts -= 1
            break if not already_assigned or attempts == 0
          end
          if not mandature.nil? and assigned_mandatures.length < 6
            assigned_mandatures << mandature
          end
        end
      end
      # Now our assigned mandatures list must be populated, it is time to save it
      # as assignments for the given user.
      assignments = assigned_mandatures.map do |mandature|
        Assignment.new user: user, resource: mandature, season: season
      end
      # Batch import of all assignments
      Assignment.import assignments
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
        assigned_to user, season, false
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
