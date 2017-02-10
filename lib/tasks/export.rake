namespace :jquest_pg do

  desc "Export all mandature"
  task :export => :environment do
    # Choose output file name
    output = ENV['output'] || "mandature-#{DateTime.now.to_s(:db)}.csv"
    # Get the content of the CSV file
    content = JquestPg::Mandature.all.to_csv
    # Special output token
    if output === 'STDOUT'
      puts content
    else
      File.write output, content
    end
  end
end
