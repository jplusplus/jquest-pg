module JquestPg
  class Engine < ::Rails::Engine
    isolate_namespace JquestPg

    initializer :active_admin do |app|
      if defined?(ActiveAdmin)
        dir = root.join('lib/jquest_pg/admin/').to_s
        ActiveAdmin.application.load_paths << dir
      end
    end

    initializer :assets do |app|
      dir = root.join('app/assets/pg').to_s
      Rails.application.config.assets.paths << dir
    end

    initializer :append_migrations do |app|
      unless root.to_s.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
