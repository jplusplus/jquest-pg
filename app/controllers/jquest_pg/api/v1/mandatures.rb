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
              page(params[:page]).
              # Serialize including associations
              as_json(include: [:person, :legislature])
          end

          desc "Return list of mandatures assigned to the user"
          get :assigned do
            authenticate!
            # Collect mandature assigned to this user
            Mandature.assigned_to(current_user).
              # Join to related tables
              includes(:person).
              includes(:legislature).
              # Serialize including associations
              as_json(include: [:person, :legislature])
          end

          params do
            requires :id, type: Integer, desc: 'mandature id'
          end
          route_param :id do

            desc "Get a mandature"
            get do
              Mandature.find(params[:id]).
                # Join to related tables
                includes(:person).
                includes(:legislature).
                # Serialize including associations
                as_json(include: [:person, :legislature])
            end
          end

        end
      end
    end
  end
end
