module JquestPg
  class PersonSerializer < ActiveModel::Serializer
    attributes :id, :fullname, :firstname, :lastname, :email, :education,
               :profession_category, :profession, :image,
               :twitter, :facebook, :gender, :birthdate, :birthplace, :phone,
               :sources
  end
end
