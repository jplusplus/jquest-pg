if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Person, :as => 'pg_person' do
    menu label: 'Persons', parent: 'Political Gaps'
    active_admin_import validate: false

    index do
      selectable_column
      id_column
      column :fullname
      column :gender
      column :birthdate
      column :birthplace
      actions
    end

    filter :fullname
    filter :gender
    filter :birthdate
    filter :birthplace

    controller do
      def permitted_params
        params.permit *active_admin_namespace.permitted_params,
                      :pg_person => [ :fullname, :firstname, :lastname, :email,
                                      :education, :profession_category,
                                      :profession, :image, :twitter, :facebook,
                                      :gender, :birthdate, :birthplace, :phone ]
      end
    end
  end
end
