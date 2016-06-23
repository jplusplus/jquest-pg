module JquestPg
  module API
    module V1
      class Base < Grape::API
        prefix 'v1'
        rescue_from :all
        format :json

        mount Persons
        mount Mandatures
      end
    end
  end
end
