namespace :jquest_pg do

  def season
    @season ||= JquestPg::ApplicationController.new.season
  end

  def check_mark
    '[' + Pastel.new.green('⌾') + ']'
  end

  def warning_mark
    '[' + Pastel.new.yellow('⚠') + ']'
  end

  def persons_with_images
    q = '%jquestapp.com%'
    JquestPg::Person.where.not(image: [nil, '']).where 'image NOT LIKE ?', q
  end

  def copy_person_image(person)
    begin
      uri = URI URI.escape(person.image)
      # Download the image
      res = Net::HTTP.get_response uri
    rescue OpenSSL::SSL::SSLError
      # puts "#{warning_mark} Unable to download #{person.image} over SSL"
      # Trying over HTTP
      person.image[/^https/] = 'http'
      # Recursive call
      copy_person_image person
    end
    # Did the download succed
    if res.is_a?(Net::HTTPSuccess) and res.header['content-type'].starts_with? 'image'
      # Create the object name
      filename = File.basename uri.path
      filename = "persons/#{person.id}/#{filename}"
      # Create a S3 object
      obj = S3_BUCKET.object(filename)
      # Upload the file
      obj.put({ acl: "public-read", body: res.body })
      # Return the public link
      obj.public_url
    else
      nil
    end
  end

  desc "Copy all person's images to Amazon S3"
  task :images => :environment do
    # Total number of element to reset or restore
    bar_tt = persons_with_images.length
    # Create progressbar
    bar = TTY::ProgressBar.new("#{check_mark} Copying #{bar_tt} images [:bar]", total: bar_tt, width: 50)
    # Iteratre over all person
    persons_with_images.find_each do |person|
      # Copy the image on S3 and update the image url
      person.update :image => copy_person_image(person)
      bar.advance
    end
  end
end
