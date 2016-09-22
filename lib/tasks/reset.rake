namespace :jquest_pg do

  def mandatures_updated
    @mandatures_updated ||= JquestPg::Mandature.updated_through_people
  end

  def season
    @season ||= JquestPg::ApplicationController.new.season
  end

  def season_users
    @season_users ||= season.users
  end

  def check_mark
    '[' + Pastel.new.green('⌾') + ']'
  end

  desc "Reset all user activities for this season"
  task :reset => :environment do
    # Counter
    ui = um = 0
    # Total number of element to reset or restore
    bar_tt = season_users.length + mandatures_updated.length
    # Create progressbar
    bar = TTY::ProgressBar.new("#{check_mark} Reseting the database [:bar]", total: bar_tt, width: 50)
    # Remove all sources and diversities
    Source.where(resource_type: [JquestPg::Mandature.name, JquestPg::Person.name]).delete_all
    JquestPg::Diversity.delete_all
    # Reset all users one by one
    season_users.each do |user|
      # Use the points table
      ui += user.points.find_or_create_by(season: season).reset! ? 1 : 0
      bar.advance
    end
    # Reset all updated mandatures
    mandatures_updated.each do |mandature|
      # Restore the original version
      if mandature.restore!
        # Remove its versions
        mandature.versions.destroy_all
        mandature.person.versions.destroy_all
        um += 1
      end
      bar.advance
    end
    # Result
    puts "#{check_mark} #{ui} user(s) reset and #{um} mandatures restored."
  end
end
