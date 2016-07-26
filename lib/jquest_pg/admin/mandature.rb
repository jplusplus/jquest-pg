if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Mandature, :as => 'pg_mandature' do
    menu label: 'Mandatures', parent: 'Political Gaps'
    active_admin_import(
      validate: true,
      batch_transaction: true,
      # Insert record one by one
      batch_size: 1,
      # Importing mandature is a destructing action
      before_import: ->(importer) { JquestPg::Mandature.delete_all },
      # Remove duplicated mandature
      before_batch_import: ->(importer) {
        pid = importer.values_at 'person_id'
        lid = importer.values_at 'legislature_id'
        if pid and lid
          # Use the two ids as a couple
          mandature = JquestPg::Mandature.where(person: pid, legislature: lid).first
          mandature.destroy if mandature
        end
      }
    )


    batch_action :restore do |ids, inputs|
      JquestPg::Mandature.find(ids).each do |mandature|
        mandature.restore!
      end
      redirect_to collection_path, :flash =>{
        :notice =>  ids.length.to_s + ' mandature'.pluralize(ids.length) + ' restored.'
      }
    end

    collection_action :restore_all, method: :get do
      JquestPg::Mandature.all.each do |mandature|
        mandature.restore!
      end
      redirect_to collection_path, notice: "All mandatures restored to initial state!"
    end

    member_action :restore, method: :get do
      resource.restore!
      redirect_to resource_path, notice: "Restored to initial state"
    end

    action_item :restore_all, only: :index do
      link_to 'Restore all', restore_all_admin_pg_mandatures_path
    end

    action_item :restore, only: :show do
      link_to 'Restore', restore_admin_pg_mandature_path
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
