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
          puts pid, lid
          # Use the two ids as a couple
          mandature = JquestPg::Mandature.where(person: pid, legislature: lid).first
          mandature.destroy if mandature
        end
      }
    )
    index do
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
