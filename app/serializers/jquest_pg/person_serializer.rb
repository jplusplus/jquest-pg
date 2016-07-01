module JquestPg
  class PersonSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id, :fullname, :firstname, :lastname, :email, :education,
               :profession_category, :profession, :image,
               :twitter, :facebook, :gender, :birthdate, :birthplace, :phone,
               :sources
    # JSON Linked Data Identifier
    # see https://www.w3.org/TR/json-ld/#node-identifiers
    attribute :@id do
      # Base path using the request
      uri = URI.join scope.request.base_url, scope.request.fullpath,
        # Joined with the engine path and its resource
        "#{jquest_pg_path}/api/v1/people/#{object.id}"
      # Convert URI instance to str
      uri.to_s
    end
  end
end
