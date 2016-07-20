module JquestPg
  module API
    module V1
      class Legislatures < Grape::API
        resource :legislatures do

          desc "Return list of legislatures"
          get do
            Legislature.page(params[:page])
          end

        end
      end
    end
  end
end
