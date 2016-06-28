module JquestPg
  class DiversitySerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id, :resource_a, :resource_b, :value
    # Use associated resources' serializers
    has_one :resource_a
    has_one :resource_b
    # JSON Linked Data Identifier
    # see https://www.w3.org/TR/json-ld/#node-identifiers
    attribute :@id do
      # Base path using the request
      uri = URI.join scope.request.base_url, scope.request.fullpath,
      # Joined with the engine path and its resource
      "#{jquest_pg_path}/api/v1/diversities/#{object.id}"
      # Convert URI instance to str
      uri.to_s
    end
  end
end
