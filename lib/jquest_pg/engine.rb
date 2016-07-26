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
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :create_assignements do |app|
      module HasAssignments
        extend ActiveSupport::Concern
        included do
          after_find :create_assignements
        end

        protected
          def create_assignements
            # Assign only if the user is member of this season (using its engine)
            if not self.member_of.nil? and self.member_of.engine == JquestPg::Engine
              # Set new assignments for this user
              JquestPg::ApplicationController.new.new_assignments! self
            end
          end
      end
      # include the extension
      User.send(:include, HasAssignments)
    end
  end
end
