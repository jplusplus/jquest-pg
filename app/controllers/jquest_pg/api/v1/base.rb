module JquestPg
  module API
    module V1

      module CsvFormatter
        def self.call(object, env)
          object.to_csv
        end
      end

      class Base < Grape::API
        prefix 'v1'
        # rescue_from :all

        content_type :json, 'application/json'
        content_type :csv, 'text/csv'

        format :json
        format :csv

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
