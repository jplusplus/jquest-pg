module JquestPg
  module API
    module V1
      class Mandatures < Grape::API
        resource :mandatures do

          desc "Return list of mandatures"
          get do
            Mandature.
              # Join to related tables
              includes(:person).
              includes(:legislature).
              # Paginates results
              page(params[:page])
          end

          desc "Return list of mandatures assigned to the user"
          get :assigned do
            authenticate!
            # Collect mandature assigned to this user
            Mandature.assigned_to(current_user, current_user.member_of, false, :pending).
              # Join to related tables
              includes(:person).
              includes(:legislature)
          end

          params do
            requires :id, type: Integer, desc: 'mandature id'
          end
          route_param :id do

            desc "Get a mandature"
            get do
              Mandature.find(params[:id])
            end

            desc "Update a mandature"
            put do
              authenticate!
              mandature = Mandature.find params[:id]
              # The mandature must be assigned to that user's progression
              authorize mandature, :update?
              # Create or update sources
              params[:sources].map! do |source|
                source.resource = mandature
                Source.update_or_create source
              end
              mandature.update_attributes permitted_params(mandature, params)
              # Return a mandature
              mandature
            end
          end

        end
      end
    end
  end
end
