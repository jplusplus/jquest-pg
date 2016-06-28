module JquestPg
  module API
    module V1
      class Base < Grape::API
        prefix 'v1'
        #rescue_from :all
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        mount Diversities
        mount People
        mount Mandatures
      end
    end
  end
end
