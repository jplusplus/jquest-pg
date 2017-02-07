module JquestPg
  class Engine < ::Rails::Engine
    isolate_namespace JquestPg

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer :active_admin do |app|
      if defined?(ActiveAdmin)
        dir = root.join('app/admin/').to_s
        ActiveAdmin.application.load_paths << dir
      end
    end

    initializer :assets do |app|
      dir = root.join('app/assets/pg').to_s
      Rails.application.config.assets.paths << dir
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :limit_assignments do |app|
      module ValidateUserAssignments
        extend ActiveSupport::Concern
        included do
          before_create :limit_assignments
        end
        protected
          def limit_assignments
            # Stop here if the season if not using this engine
            return true if season.engine != JquestPg::Engine
            # Debug output
            logger.debug "Checking assignments for #{user} on level #{level}"
            # Returns true if the maximum hasn't been reached
            return user.assignments.where(season: season, level: level).count() < Mandature::MAX_ASSIGNABLE
          end
      end
      # include the extension
      Assignment.send(:include, ValidateUserAssignments)
    end
  end
end
