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

          post do
            Diversity.create value: params.value,
                             resource_a: Person.find(params.resource_a.id),
                             resource_b: Person.find(params.resource_b.id)
          end

          get :request do
            authenticate!
            # No one unassigned by default
            unassigned = Person.none
            assigned = progression.assignment.resource.person
            # Loop until a diversity request can be created with this unassigned person
            # Person.assigned_to(current_user).order("RANDOM()").each
            begin
              # An assigned person can only be in diversity twice
              return nil if Diversity.occurrences(assigned) > 2
              # Loop until a diversity request can be created with this unassigned person
              loop do
                # Collect a random person not assigned to this user with an image
                unassigned = Person.unassigned_to(current_user).where.not(image: nil).order("RANDOM()").limit(1).first
                # Break if there is to few unassigned people
                break if unassigned.nil?
                # Break if the people have not been compared yet
                break unless Diversity.both_exists?(unassigned, assigned)
              end
              # Nothing to propose
              return nil if unassigned.nil?
              # Instanciate a diversity record without saving it
              Diversity.new(resource_a: unassigned, resource_b: assigned)
            end
          end
        end
      end
    end
  end
end
