if defined?(ActiveAdmin)
  ActiveAdmin.register_page 'Dashboard', :namespace => 'pg' do
    menu label: 'Political Gaps Dashboard'
  end
end
