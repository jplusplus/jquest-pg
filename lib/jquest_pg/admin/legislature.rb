if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Legislature, :as => 'pg_legislature' do
    menu label: 'Legislatures', parent: 'Political Gaps'
    active_admin_import validate: false

    index title: 'Legislatures' do
      selectable_column
      id_column
      column :name
      column :name_english
      column :name_local
      column :territory
      column :country
      actions
    end

    filter :name
    filter :name_english
    filter :name_local
    filter :territory
    filter :country

    controller do
      def permitted_params
        params.permit *active_admin_namespace.permitted_params,
                      :pg_legislature => [ :name, :name_english, :name_local,
                                           :territory, :difficulty_level,
                                           :country, :start_date, :end_date,
                                           :source, :list, :number_of_members ]
      end
    end
  end
end
