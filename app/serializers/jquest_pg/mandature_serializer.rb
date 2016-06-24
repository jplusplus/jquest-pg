module JquestPg
  class MandatureSerializer < ActiveModel::Serializer
    attributes :id, :legislature, :person, :political_leaning,
               :role, :group, :area, :chamber
  end
end
