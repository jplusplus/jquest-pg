module JquestPg
  module API
    module V1
      class Legislatures < Grape::API
        resource :legislatures do

          desc "Return list of legislatures"
          get do
            policy_scope(Legislature).
              # Sort by id
              order(:id).
              page(params[:page]).
              # Default limit is 25
              per(params[:limit])
          end

        end
      end
    end
  end
end
