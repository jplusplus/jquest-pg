if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Legislature, :as => 'pg_legislature' do
    menu label: 'Legislatures', parent: 'Political Gaps'

    index title: 'Legislatures' do
      selectable_column
      id_column
      column :name
      column :territory
      column :country
      column :languages
      column :difficulty_level
      column :start_date
      column :end_date
      actions
    end

    filter :name
    filter :name_english
    filter :name_local
    filter :territory
    filter :country


    form :as => :pg_legislature do |f|
      f.semantic_errors
      f.inputs
      f.actions
    end

    sidebar "Shortcuts", only: [:show, :edit] do
      ul do
        li link_to "Mandatures",  admin_pg_mandatures_path(q: { legislature_id_eq: pg_legislature.id })
      end
    end

    controller do
      def permitted_params
        params.permit *active_admin_namespace.permitted_params,
                      :pg_legislature => [ :name, :name_english, :name_local,
                                           :territory, :difficulty_level,
                                           :country, :start_date, :end_date,
                                           :source, :list, :number_of_members,
                                           :languages ]
      end
    end
  end
end
