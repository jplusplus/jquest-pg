module JquestPg
  module API
    module V1
      class Legislatures < Grape::API
        resource :legislatures do

          paginate
          desc "Return list of legislatures"
          get do
            garner do
              paginate policy_scope(Legislature).
                # Sort by id
                order(:id).
                # For caching
                to_a
            end
          end

        end
      end
    end
  end
end
