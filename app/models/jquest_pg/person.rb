module JquestPg
  class Person < ActiveRecord::Base
    has_paper_trail
    has_many :mandatures
    after_update :track_activities

    def display_name
      fullname
    end

    def track_activities
      # Find the last version of this model
      uid = self.versions.last.nil? ? nil : self.versions.last.whodunnit
      # This someone must exist!
      unless uid.nil?
        # Find the user
        user = User.find uid
        # Does the gender have been touch (even if it didn't changed)
        if self.gender_touched?
          # Get user progression
          progression = JquestPg::ApplicationController.new.progression user
          # Create a taxonomy for this level, round 1 (genderizing)
          taxonomy = "LEVEL:#{progression[:level]}:ROUND:1:TASK:FINISHED"
          # Find assignment for this user
          assignment = user.assignments.where(resource: self).first
          # We found it!
          unless assignment.nil?
            # Take its id
            aid = assignment.id
            # And save the activity
            Activity.find_or_create_by user: user, taxonomy: taxonomy, value: aid, points: 1
          end
        end
      end
    end

    def gender=(value)
      super
      # To track touch on gender field (even if the value didn't changed)
      @gender_touched = true
    end

    def gender_touched?
      @gender_touched.present? and @gender_touched
    end

    def self.assign_to!(user, season=nil)
      # A array of assigned person
      assigned_persons = []
      # Get the list of legislatures that can be assigned to the user
      assignable_legislatures = Legislature.assignable_to user
      # Number of persons picked from each legislatures depends of the number of legislature
      per_legislatures = [(6 / assignable_legislatures.length).ceil, 1].max
      # For each legislature...
      assignable_legislatures.each do |legislature|
        # Pick enough persons!
        per_legislatures.times.each do
          person = nil
          # Attempts available to find a person (no more than 10)
          attempts = 10
          loop do
            # Rick a random person not already assigned
            person = legislature.persons.where.not(id: assigned_persons).order("RANDOM()").first
            # Ensure no one else is assigned to that person
            already_assigned = Assignment.exists? resource: person
            # Save the attempt
            attempts -= 1
            break if not already_assigned or attempts == 0
          end
          assigned_persons << person unless person.nil?
        end
      end
      # Now our assigned persons list must be populated, it is time to save it
      # as assignments for the given user.
      assignments = assigned_persons.map do |person|
        Assignment.new user: user, resource: person, season: season
      end
      # Batch import of all assignments
      Assignment.import assignments
      # Returns the persons
      assigned_persons
    end

    def self.assigned_to(user)
      ids = user.assignments.where(resource_type: Person).map(&:resource_id)
      where(id: ids)
    end
  end
end
