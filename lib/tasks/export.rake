namespace :jquest_pg do

  desc "Export all mandature"
  task :export => :environment do
    output = ENV['output'] || 'all.csv'
    File.open(output, 'w') do |file|
      file.write JquestPg::Mandature.all.to_csv
    end
  end
end
