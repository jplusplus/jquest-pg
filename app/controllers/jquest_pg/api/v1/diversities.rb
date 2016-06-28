module JquestPg
  module API
    module V1
      class Diversities < Grape::API
        resource :diversities do
          desc "Return list of diversities"
          get do
            Diversity.page(params[:page])
          end
        end
      end
    end
  end
end
