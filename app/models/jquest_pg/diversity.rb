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
        points: 100,
        taxonomy: 'diversity'
      }
      # And save the activity
      Activity.find_or_create_by **activity
    end

    def display_name
      if value == 0
        "#{resource_a} looks more like a politician than #{resource_b}"
      elsif value == 1
        "#{resource_b} looks more like a politician than #{resource_a}"
      else
        "#{resource_a} and #{resource_a} look equally like a politician"
      end
    end

    def self.states
      # A hash containing every resource's types
      @states ||= { }
    end

    def self.state_as_pairs
      states.map do |resource, state|
        [(state.points.to_f / state.comparaison.to_f), resource]
      end
    end

    def self.resource_state(resource)
      states[resource] ||= OpenStruct.new(points: 0,  comparaison: 0)
    end

    def self.as_ranking
      # For each Diversity made
      Diversity.all.each do |diversity|
        unless diversity.resource_a.nil? or diversity.resource_b.nil?
          [diversity.resource_a, diversity.resource_b].to_enum.with_index(1) do |resource, i|
            resource_state(resource).comparaison += 1
            resource_state(resource).points += (i == diversity.value ? 1 : 0)
          end
        end
      end

      state_as_pairs.sort { |a, b| a <=> b }
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
