module JquestPg
  module API
    module V1
      class Mandatures < Grape::API
        resource :mandatures do

          desc "Return list of mandatures"
          params do
            optional :legislature_id_eq, type: Integer
            optional :legislature_country_eq, type: String
            optional :legislature_territory_cont, type: String
            optional :person_fullname_or_legislature_name_cont, type: String
          end
          get do
            Mandature.
              # We allow filtering
              search(declared params).
              result.
              # Join to related tables
              eager_load(:person).
              eager_load(:legislature).
              # Load sources
              includes(person: :sources).
              includes(:sources).
              # Sort by id
              order(:id).
              # Paginates results
              page(params[:page]).
              # Default limit is 25
              per(params[:limit])
          end


          desc "Return summary about all mandatures"
          get :summary do
            # Empty hash containing result
            result = {}
            # Mandatures assigned to the user
            assigned = Mandature.assigned_to(current_user, current_user.member_of, false, :pending)
            # All unfinished mandatures
            global = Mandature.
              # Join to related tables
              eager_load(:person).
              eager_load(:legislature).
              # Only current legislature
              where('jquest_pg_legislatures.end_date > ?', Time.now)
            # Create a hash of values for the two subsets
            { global: global, assigned: assigned }.map do |key, mandatures|
              # Count by gender
              gender = mandatures.select { |m| m.person and not m.person.gender.blank? }
              gender = gender.group_by { |m| m.person.gender }
              gender = gender.map { |k,v| [k, v.length] }.to_h
              # Age values at tehe begin of the legislature
              ages = mandatures.map(&:age).compact
              # Returns a hash
              result[key] = {
                total: mandatures.length,
                gender: gender,
                age: {
                  min: ages.empty? ? nil : ages.min,
                  max: ages.empty? ? nil : ages.max,
                  median: ages.empty? ? nil : median(ages)
                }
              }
            end
            # Return the result hash
            result
          end

          resource :assigned do
            desc "Return list of mandatures assigned to the user"
            get do
              authenticate!
              # Collect mandature assigned to this user
              Mandature.assigned_to(current_user, current_user.member_of, true).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id).
                # Paginates results
                page(params[:page]).
                # Default limit is 25
                per(params[:limit])
            end

            desc "Return list of mandatures assigned to the user and still pending"
            get :pending do
              authenticate!
              # Collect mandature assigned to this user
              Mandature.assigned_to(current_user, current_user.member_of, true, :pending).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id).
                # Paginates results
                page(params[:page]).
                # Default limit is 25
                per(params[:limit])
            end


            desc "Return list of mandatures assigned to the user and done"
            get :done do
              authenticate!
              # Collect mandature assigned to this user
              Mandature.assigned_to(current_user, current_user.member_of, true, :done).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id).
                # Paginates results
                page(params[:page]).
                # Default limit is 25
                per(params[:limit])
            end
          end

          params do
            requires :id, type: Integer, desc: 'mandature id'
          end
          route_param :id do

            desc "Get a mandature"
            get do
              Mandature.find(params[:id])
            end

            desc "Update a mandature"
            put do
              authenticate!
              mandature = Mandature.find params[:id]
              # The mandature must be assigned to that user's progression
              authorize mandature, :update?
              # Create or update sources
              params[:sources].map! do |source|
                source.resource = mandature
                Source.update_or_create source
              end
              mandature.update_attributes permitted_params(mandature, params)
              # Go to the next round
              current_user_point.next_round unless progression.remaining > 0
              # Return a mandature
              mandature
            end

            desc "Skip a mandature"
            put :skip do
              authenticate!
              mandature = Mandature.find params[:id]
              # The mandature must be assigned to that user's progression
              authorize mandature, :update?
              # Add an activity saying we skip this mandature
              mandature.skipped_by current_user
              # Go to the next round
              current_user_point.next_round unless progression.remaining > 0
              # Return a mandature
              mandature
            end
          end

        end
      end
    end
  end
end
