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
    # Question to ask
    question = "Which legislature should we import?"
    # Pick a row!
    row = prompt.enum_select question do |menu|
      legislatures.rows.drop(1).each do |row|
        menu.choice row[ worksheet_col_idx(legislatures, 'name') ], row
      end
    end
    # Build a hash
    build_worksheet_hash legislatures, row
  end

  def legislature_fields
    [:name_english, :name_local, :territory, :languages,
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

  def pick_similar_person(mandature_hash, summary=false)
    # Any similar person?
    if similar_persons(mandature_hash).any?
      # Automerge!
      if (ENV['merge'] || 'prompt').to_sym == :all
        similar_persons(mandature_hash).first
      else
        # Print a table with information about the ambiguous manature
        mandature_as_table mandature if summary
        # Build a question with a specific format
        sentence = "\r#{question_mark} We found several or ambiguous persons named " +
                   pastel.bold(mandature_hash[:fullname])
        # Prompt user to
        prompt.select sentence do |menu|
          # For each similar person...
          similar_persons(mandature_hash).each do |person|
            # Create a choise
            menu.choice "Merge with " + person.description, person
          end
          # We can also decide to return nil (and so create a new person)
          menu.choice 'Create a new one', nil
        end
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

  def similar_persons(mandature_hash)
    # A hash of similar person
    @similars ||= {}
    # Get the similar person by fullname
    @similars[mandature_hash] ||= persons_similar_by( mandature_hash.slice(:fullname) )
  end

  def find_similar_person(mandature_hash)
    # The person has a birthdate?
    if mandature_hash[:birthdate].present?
      # Any similar person?
      if similar_persons(mandature_hash).any?
        # Iterate over similar persons
        similar_persons(mandature_hash).detect do |similar|
          # Same birthdate?
          similar.birthdate == mandature_hash[:birthdate].to_date
        end
      end
    end
  end

  def find_among_similar_legislature(legislature, mandature_hash)
    person = nil
    # Loop into similar legislature
    legislature.similars.detect do |similar|
      # Shall we find
      person ||= similar.persons.find_by_fullname mandature_hash[:fullname]
    end
    # Return the person (or nil)
    person
  end

  def find_person(legislature, mandature_hash)
    ## There is basicaly 4 ways to find a person
    ## 1
    # Try to find this person in the legislature
    person ||= legislature.persons.find_by_fullname mandature_hash[:fullname]
    ## 2
    # Try to find a person born at the same date with a similar fullname
    person ||= find_similar_person mandature_hash
    ## 3
    # Try to find a person with the exact same fullname among the members of a similar legislature
    person ||= find_among_similar_legislature legislature, mandature_hash
    ## 4
    # At last, try to pick someone among the person with a similar fullname
    person ||= pick_similar_person mandature_hash
  end

  desc "Download mandatures from masterfile"
  task :sync do
    # Counter
    person_created = person_updated = 0
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
    # Create a progress bar
    bar_tt = legislature_worksheet.rows.length - 1
    bar = TTY::ProgressBar.new("#{check_mark} Syncronizing the database [:bar]", total: bar_tt, width: 50)
    # A mandature is an association between a person and a legislature.
    legislature_worksheet.rows.drop(1).each do |row|
      # next step
      bar.advance 1
      # Generate a hash for this row according to the first line of the worksheet
      mandature_hash = build_worksheet_hash(legislature_worksheet, row)
      # Skip persons with no fullname
      break if mandature_hash[:fullname].blank?
      # Find the person for this legislature (if any)
      person = find_person legislature, mandature_hash
      # Count person created
      person_created += person.nil? ? 1 : 0
      person_updated += person.nil? ? 0 : 1
      # We use the person object we found
      person.update! mandature_hash.slice(*person_fields) unless person.nil?
      # Or we create the person!
      person ||= JquestPg::Person.create! mandature_hash.slice(*person_fields)
      # We may now create the mandature to join the person to the legislature
      mandature = JquestPg::Mandature.find_or_create_by(legislature: legislature, person: person)
      # And we update its attributes
      mandature.update! mandature_hash.slice(*mandature_fields)
    end
    # Finish the bar
    bar.finish
    # Finally, output the result
    puts "#{check_mark} #{person_created} person(s) created, #{person_updated} merged."
  end
end
