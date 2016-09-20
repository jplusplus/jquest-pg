if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Diversity, :as => 'pg_diversity' do
    menu label: 'Diversities', parent: 'Political Gaps'

    filter :value

    index title: 'Diversities' do
      selectable_column
      id_column
      column :display_name
      actions
    end

    form :as => :pg_diversity do |f|
      f.semantic_errors
      f.inputs
      f.actions
    end

    controller do
      def scoped_collection
        super.includes :resource_a, :resource_b
      end

      def permitted_params
        params.permit *active_admin_namespace.permitted_params,
                      :pg_diversity => [ :resource_a, :resource_b, :value ]
      end
    end
  end
end
