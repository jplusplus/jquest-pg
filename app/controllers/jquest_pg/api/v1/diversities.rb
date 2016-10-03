module JquestPg
  module API
    module V1
      class Diversities < Grape::API
        resource :diversities do
          desc "Return list of diversities"
          get do
            Diversity.
              page(params[:page]).
              # Default limit is 25
              per(params[:limit])
          end

          desc "Create a diversity object"
          post do
            diversity = Diversity.create value: params.value,
                                         resource_a: Person.find(params.resource_a.id),
                                         resource_b: Person.find(params.resource_b.id)
            # Could this diversity lead us to the next level?
            if DiversityPolicy.new(current_user, diversity).level_up?
              # Go to the next level
              current_user_point.next_level
            end
            # Returns the new diversity
            diversity
          end

          get :request do
            authenticate!
            # No one unassigned by default
            unassigned = Assignment.none
            person = nil
            # Pick a person among the user assignments
            current_user.assignments.order(:resource_id).where(status: :pending).each do |assignment|
              unless current_user.activities.exists? assignment: assignment, taxonomy: 'diversity'
                person ||= assignment.resource.person
              end
            end
            # Stop if no one has been found
            return nil if person.nil?
            # Loop until a diversity request can be created with this unassigned person
            10.times.each do
              # Get other users' assignments
              other_users_assignments = Assignment.unassigned_to(current_user).
                # ...joins through the mandatures table using the assignment's resource_id
                joins('INNER JOIN jquest_pg_mandatures ON jquest_pg_mandatures.id = assignments.resource_id').
                joins('INNER JOIN jquest_pg_people ON jquest_pg_people.id = jquest_pg_mandatures.person_id').
                # Filter other assignments to only get the one with images
                where('jquest_pg_people.image IS NOT NULL').
                where("jquest_pg_people.image != ''")
              # Collect a random assignment
              unassigned = other_users_assignments.order("RANDOM()").limit(1).first
              # Break if there is to few unassigned people
              break if unassigned.nil?
              # Break if the people have not been compared yet
              break if unassigned.resource.person.diversity_count < 1
            end
            # Nothing to propose
            return nil if unassigned.nil?
            # Instanciate a diversity record without saving it
            Diversity.new(resource_a: unassigned.resource.person, resource_b: person)
          end

          get :ranking do
            authenticate!
            # Return all diversities ranking
            Diversity.as_ranking.map { |item| item[1] }
          end
        end
      end
    end
  end
end
