module JquestPg
  module API
    module V1
      class People < Grape::API
        resource :people do

          desc "Return list of people"
          get do
            Person.
              page(params[:page]).
              # Default limit is 25
              per(params[:limit])
          end

          params do
            requires :id, type: Integer, desc: 'person id'
          end
          route_param :id do

            desc "Get a person"
            get do
              Person.find(params[:id])
            end

            desc "Update a person"
            put do
              authenticate!
              person = Person.find params[:id]
              # The person must be assigned to that user's progression
              authorize person, :update?
              # Create or update sources
              params[:sources].map! do |source|
                source.resource = person
                Source.update_or_create source
              end
              person.update_attributes permitted_params(person, params)
              # Go to the next round
              current_user_point.next_round unless progression.remaining > 0
              # Return a person
              person
            end

            desc "Genderize a person"
            params do
              requires :gender, type: String, desc: 'new gender'
            end
            post :genderize do
              authenticate!
              person = Person.find params[:id]
              # The person must be assigned to that user's progression
              authorize person, :update?
              # Change the gender
              person.gender = params[:gender]
              # Ensure a version is created even if the value is the same
              person.touch_with_version unless person.gender_changed?
              person.save!
              # Go to the next round
              current_user_point.next_round unless progression.remaining > 0
              # Return a person
              person
            end
          end

        end
      end
    end
  end
end
