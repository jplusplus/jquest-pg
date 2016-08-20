if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Person, :as => 'pg_person' do
    menu label: 'People', parent: 'Political Gaps'

    index title: 'People' do
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

    form :as => :pg_person do |f|
      f.semantic_errors
      f.inputs do
        f.input :fullname
        f.input :firstname
        f.input :lastname
        f.input :email
        f.input :education
        f.input :profession_category
        f.input :profession
        f.input :image
        f.input :twitter
        f.input :facebook
        f.input :gender
        f.input :birthdate, as: :datepicker
        f.input :birthplace
        f.input :phone
      end
      f.actions
    end

    sidebar "Shortcuts", only: [:show, :edit] do
      ul do
        li link_to "Mandatures",  admin_pg_mandatures_path(q: { person_id_eq: pg_person.id })
      end
    end

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
