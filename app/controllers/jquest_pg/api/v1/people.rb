module JquestPg
  module API
    module V1
      class People < Grape::API
        resource :people do

          desc "Return list of people"
          get do
            Person.page(params[:page])
          end

          desc "Return list of people assigned to the user"
          get :assigned do
            authenticate!
            # Collect person assigned to this user
            Person.assigned_to current_user
          end

          params do
            requires :id, type: Integer, desc: 'person id'
          end
          route_param :id do

            desc "Get a person"
            get do
              Person.find(params[:id])
            end

            desc "Genderize a person"
            params do
              requires :gender, type: String, desc: 'new gender'
            end
            post :genderize do
              person = Person.find(params[:id])
              # The person must be assigned to that user's progression
              if Mandature.find(progression[:assignment]["resource_id"]).person == person
                # Change the gender
                person.gender = params[:gender]
                # Ensure a version is created even if the value is the same
                person.touch_with_version unless person.gender_changed?
                person.save!
                # Return a person
                person
              else
                error!({ error: 'Unauthorized.' }, 403)
              end
            end
          end

        end
      end
    end
  end
end
