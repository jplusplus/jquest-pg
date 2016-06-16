module JquestPg
  class Person < ActiveRecord::Base
    has_paper_trail
    has_many :mandatures

    def display_name
      fullname
    end

    def self.assign_to!(user, season=nil)
      # A array of assigned person
      assigned_persons = []
      # Get the list of legislatures that can be assigned to the user
      assignable_legislatures = Legislature.assignable_to user
      if assignable_legislatures.length
        # Number of persons picked from each legislatures depends of the number of legislature
        persons_per_legislatures = (6 / assignable_legislatures.length).ceil
        # For each legislature...
        assignable_legislatures.each do |legislature|
          # Pick enough persons!
          persons_per_legislatures.times.each do
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
