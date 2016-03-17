if defined?(ActiveAdmin)
  ActiveAdmin.register JquestPg::Territory, :as => 'Territory', :namespace => 'pg' do
    permit_params :name, :country

    index do
      selectable_column
      id_column
      column :name
      column :country
      actions
    end

    filter :name
    filter :country

    show :title => proc{|territory| territory.name }

    form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :country, :priority_countries => []
      end
      f.actions
    end

  end
end
