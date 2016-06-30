module JquestPg
  class Diversity < ActiveRecord::Base

    has_paper_trail
    belongs_to :resource_a, polymorphic: true
    belongs_to :resource_b, polymorphic: true
    after_create :track_activities

    def track_activities
      # Find the last version of this model
      uid = versions.last.nil? ? nil : versions.last.whodunnit
      # This someone must exist!
      return if uid.nil?
      # Find the user
      user = User.find uid
      # Find assignment for this user...
      assignment = begin
        resource_a.as_assignments.find_by(user: user) or
        resource_b.as_assignments.find_by(user: user)
      end
      # This assignment must exist!
      return if assignment.nil?
      # Get user progression
      progression = JquestPg::ApplicationController.new.progression user
      # ROUND 3
      # Build a hash describing the new activity
      activity = {
        user: user,
        resource: self,
        assignment: assignment,
        points: 1,
        taxonomy: 'diversity'
      }
      # And save the activity
      Activity.find_or_create_by **activity
    end

    def display_name
      if value == -1
        "#{resource_a} looks more like a politician than #{resource_b}"
      elsif value == 1
        "#{resource_b} looks more like a politician than #{resource_a}"
      end
    end

    def self.types
      ActiveRecord::Base.send(:subclasses).map(&:name)
    end

    def self.both_exists?(a, b)
      where(resource_a: a, resource_b: b).exists? or
      where(resource_a: b, resource_b: a).exists?
    end

    def self.occurrences(resource)
      where(resource_a: resource).count() + where(resource_b: resource).count()
    end
  end
end
