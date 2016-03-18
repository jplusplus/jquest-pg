if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Territory, :as => 'pg_territory' do
    menu label: 'Territory', parent: 'Political Gaps'
    active_admin_import

    index do
      selectable_column
      id_column
      column :name
      column :country
      actions
    end

    filter :name
    filter :country

    form :as => :pg_territory do |f|
      f.inputs "Details" do
        f.input :name
        f.input :country, :priority_countries => []
      end
      f.actions
    end

    controller do
      def permitted_params
        params.permit *active_admin_namespace.permitted_params,
                      :pg_territory => [ :name, :country ]
      end
    end
  end
end
