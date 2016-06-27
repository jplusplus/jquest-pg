module JquestPg
  class LegislatureSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id , :name, :name_english, :name_local, :territory,
               :difficulty_level, :country, :start_date, :end_date,
               :source, :list, :number_of_members, :languages
    # JSON Linked Data Identifier
    # see https://www.w3.org/TR/json-ld/#node-identifiers
    attribute :@id do
      # Base path using the request
      uri = URI.join scope.request.base_url, scope.request.fullpath,
      # Joined with the engine path and its resource
      "#{jquest_pg_path}/api/v1/legislatures/#{object.id}"
      # Convert URI instance to str
      uri.to_s
    end
  end
end
