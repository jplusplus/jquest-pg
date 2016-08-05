if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Mandature, :as => 'pg_mandature' do
    menu label: 'Mandatures', parent: 'Political Gaps'

    batch_action :restore, confirm: "This restore the initial state of selected mandature(s)"  do |ids, inputs|
      JquestPg::Mandature.find(ids).each do |mandature|
        mandature.restore!
      end
      redirect_to collection_path, :flash =>{
        :notice =>  ids.length.to_s + ' mandature'.pluralize(ids.length) + ' restored.'
      }
    end

    member_action :restore, method: :get do
      resource.restore!
      redirect_to resource_path, notice: "Restored to initial state"
    end

    action_item :restore, only: :show do
      link_to 'Restore Mandatures', restore_admin_pg_mandature_path
    end

    index title: 'Mandatures' do
      selectable_column
      id_column
      column :person
      column :legislature
      column :group
      column :role
      column :area
      column :chamber
      actions
    end

    form :as => :pg_mandature do |f|
      f.semantic_errors
      f.inputs
      f.actions
    end

    controller do
      def permitted_params
        params.permit *active_admin_namespace.permitted_params,
                      :pg_mandature => [ :legislature_id, :person_id,
                                         :political_leaning, :role, :group,
                                         :area, :chamber ]
      end
    end
  end
end
