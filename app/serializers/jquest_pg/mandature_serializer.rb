module JquestPg
  class MandatureSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :id, :legislature, :person, :political_leaning,
               :role, :group, :area, :chamber, :sources, :completion
    # Use associated resources' serializers
    has_one :legislature
    has_one :person
    # JSON Linked Data Identifier
    # see https://www.w3.org/TR/json-ld/#node-identifiers
    attribute :@id do
      # Base path using the request
      uri = URI.join scope.request.base_url, scope.request.fullpath,
      # Joined with the engine path and its resource
      "#{jquest_pg_path}/api/v1/mandatures/#{object.id}"
      # Convert URI instance to str
      uri.to_s
    end
  end
end
