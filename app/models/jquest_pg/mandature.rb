module JquestPg
  class Mandature < ActiveRecord::Base
    has_paper_trail
    belongs_to :legislature
    belongs_to :person
    has_many :sources, foreign_key: :resource_id
    has_many :assignments, foreign_key: :resource_id
    after_update :track_activities

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
      if progression[:round] == 2
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

    def self.some_are_assigned_to?(user, season=user.member_of)
      self.assigned_to(user, season, true).length > 0
    end

    def self.assign_to!(user, season=user.member_of)
      # A array of assigned mandature
      assigned_mandatures = []
      # Get the list of legislatures that can be assigned to the user
      assignable_legislatures = Legislature.assignable_to user
      # Number of mandature picked from each legislatures depends of the number of legislature
      per_legislatures = (6 / [assignable_legislatures.length, 1].max).ceil
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
          assigned_mandatures << mandature unless mandature.nil?
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

    def self.assigned_to(user, season=user.member_of, force=true)
      ids = user.assignments.where(resource_type: Mandature).map(&:resource_id)
      # Collect mandatures assigned to that user
      mandatures = where(id: ids)
      # The user may not have assigned mandature yet
      if force and mandatures.length == 0
        # Assign mandature to the user
        mandatures = Mandature.assign_to! user, season
      end
      # And returns mandatures list
      mandatures
    end
  end
end
