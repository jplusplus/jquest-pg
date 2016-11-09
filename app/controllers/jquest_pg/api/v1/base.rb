module JquestPg
  module API
    module V1

      module CsvFormatter
        def self.call(objects, env)
          objects.to_csv
        end
      end

      class Base < Grape::API
        prefix 'v1'
        #rescue_from :all

        content_type :csv, 'text/csv'
        content_type :json, 'application/json'

        format :csv
        format :json

        formatter :json, Grape::Formatter::ActiveModelSerializers
        formatter :csv, CsvFormatter

        mount Diversities
        mount People
        mount Mandatures
        mount Legislatures
      end
    end
  end
end
