require "google_drive"
require 'tty'
require 'tty-prompt'
require 'unicode_utils/downcase'

class String
  # Normalize spaces and fingerprint.
  # https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth
  # https://github.com/OpenRefine/OpenRefine/blob/master/main/src/com/google/refine/clustering/binning/FingerprintKeyer.java
  def fingerprint
    UnicodeUtils.downcase(gsub(/[[:space:]]+/, ' ').strip).gsub(/\p{Punct}|\p{Cntrl}/, '').split.uniq.sort.join(' ').tr(
      "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
      "aaaaaaaaaaaaaaaaaaccccccccccddddddeeeeeeeeeeeeeeeeeegggggggghhhhiiiiiiiiiiiiiiiiiijjkkkllllllllllnnnnnnnnnnnoooooooooooooooooorrrrrrsssssssssttttttuuuuuuuuuuuuuuuuuuuuwwyyyyyyzzzzzz")
  end
end

namespace :jquest_pg do
  # File path to the session config
  SESSION_FILEPATH = File.join(Dir.pwd, 'config', 'google-session.json')
  # Google OAuth Service Credentials
  CLIENT_ID = ENV['GOOGLE_CLIENT_ID']
  CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']
  # Masterfile key
  MASTERFILE_URL = 'https://docs.google.com/spreadsheets/d/11hhYC6iVR8Uczar_FQv-AmnjG2RyCMAtjPKl1Th_xwY/edit'

  def session
    @session ||= GoogleDrive.saved_session(SESSION_FILEPATH, nil, CLIENT_ID, CLIENT_SECRET)
  end

  def legislatures
    @legislatures ||=begin
      # Inform the user
      puts "#{check_mark} Getting all legislatures from #{pastel.bold(MASTERFILE_URL)}"
      download_worksheet_by_url(MASTERFILE_URL, 'legislature')
    end
  end

  def worksheet_col_idx(worksheet, name)
    # The list column is called 'list'
    worksheet.rows[0].index { |value| value == name }
  end

  def pick_legislature_hash
    row = prompt.enum_select "Which legislature should we import?" do |menu|
      legislatures.rows.drop(1).each do |row|
        menu.choice row[ worksheet_col_idx(legislatures, 'name') ], row
      end
    end
    # Build a hash
    build_worksheet_hash legislatures, row
  end

  def legislature_fields
    [:name_english, :name_local, :chamber, :territory, :languages,
     :difficulty_level, :country, :start_date, :end_date, :number_of_members]
  end

  def person_fields
    [:firstname, :lastname, :fullname,
     :birthdate, :birthplace, :profession, :phone, :gender]
  end

  def mandature_fields
    [:role, :group]
  end

  def mandature_as_table(mandature)
    # Projected field
    projection = mandature.slice *(person_fields + mandature_fields)
    # Create a table with the right header
    table = TTY::Table.new projection.keys, [ projection.values ]
    # Then render it!
    puts TTY::Table::Renderer::Unicode.new(table).render
  end

  def spinner
    @spinner ||=begin
      s = TTY::Spinner.new("[:spinner] Loading ...", clear: true, format: :dots)
      # Remove the spinner instance after it is done
      s.on(:done) { @spinner = nil }
      s
    end
  end

  def prompt
    @prompt ||= TTY::Prompt.new prefix: "#{question_mark} ", active_color: :cyan
  end

  def persons
    @persons ||= JquestPg::Person.all
  end

  def pastel
    @pastel ||= Pastel.new
  end

  def question_mark
    '[' + pastel.green('?') + ']'
  end

  def check_mark
    '[' + pastel.green('⌾') + ']'
  end

  def persons_similar_by(hash)
    persons.select do |person|
      hash.keys.all? do |key|
        person.read_attribute(key).to_s.fingerprint == hash[key].to_s.fingerprint
      end
    end
  end

  def pick_similar_person(mandature, similars, summary=false)
    # Print a table with information about the ambiguous manature
    mandature_as_table mandature if summary
    # Build a question with a specific format
    sentence = "We found several or ambiguous persons named " +
               pastel.bold(mandature[:fullname])
    # Prompt user to
    prompt.select sentence do |menu|
      menu.choice 'Create a new one', nil
      similars.each do |person|
        menu.choice "Merge with " + person.description, person
      end
    end
  end

  def build_worksheet_hash(worksheet, row)
    # Get worksheet's headers
    headers = worksheet.rows[0]
    Hash[*headers.each_with_index.map { |h, idx| [ h.to_sym, row[idx] ] }.flatten]
  end

  def download_worksheet_by_url(url, worksheet)
    # Start a spinner
    spinner.start
    # Get the selected legislature spreadsheet and the worksheet named 'data'
    ws = session.spreadsheet_by_url(url).worksheet_by_title(worksheet)
    # Start a spinner
    spinner.stop
    # Return the worksheet
    ws
  end

  desc "Download legislatures list from masterfile"
  task :sync do
    person_created = 0
    person_updated = 0
    # Select a legislature spreadsheet and gets it as a hash
    legislature_hash = pick_legislature_hash
    # Output the choice's URL
    puts "#{check_mark} Getting legislature data from #{pastel.bold(legislature_hash[:list])}"
    # Get the selected legislature spreadsheet and the worksheet named 'data'
    legislature_worksheet = download_worksheet_by_url legislature_hash[:list], 'data'
    # Add the legislature to the database
    legislature = JquestPg::Legislature.find_or_create_by! legislature_hash.slice(:name) do |legislature|
      # We may set the legislature fields
      legislature.update legislature_hash.slice(*legislature_fields)
    end
    # A mandature is an association between a person and a legislature.
    legislature_worksheet.rows.drop(1).each do |mandature_row|
      # The person is not identified yet
      person = nil
      # Generate a hash for this row according to the first line of the worksheet
      mandature_hash = build_worksheet_hash(legislature_worksheet, mandature_row)
      # Get all person with a similar fullname
      # (we use an offline method to compare fingerprint)
      if (similars = persons_similar_by( mandature_hash.slice(:fullname) ) ).length > 0
        # They have the same name, we must find a way to differenciate them.
        # We check the birthdate.
        if mandature_hash[:birthdate].present?
          # The same person is the one with the same birthdate
          person = similars.select{ |s| s.birthdate == mandature_hash[:birthdate] }.first
        end
        # We didn't find anyone using the birthdate
        if person.nil?
          # Ask the user to choose what we shoul do
          person = pick_similar_person(mandature_hash, similars)
        end
      end
      # No one is similar
      if person.nil? and mandature_hash[:fullname].present?
        # We create the person!
        person = JquestPg::Person.create! mandature_hash.slice(person_fields)
        # Count person created
        person_created += 1
      # Merge values
      else
        # We use the person object we found
        person.update! mandature_hash.slice(person_fields)
        # Count person updated
        person_updated += 1
      end
      # We may now create the mandature to join the person to the legislature
      mandature = JquestPg::Mandature.find_or_create_by(legislature: legislature, person: person)
      # And we update its attributes
      mandature.update! mandature_hash.slice(mandature_fields)
    end
    # Finally, output the result
    puts "#{check_mark} #{person_created} person(s) created, #{person_updated} updated."
  end
end
