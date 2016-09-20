class AddAgeRangeToMandatures < ActiveRecord::Migration
  def up
    # Add the new column
    add_column :jquest_pg_mandatures, :age_range, :string
    # Migrate data to fill this column
    say_with_time "fill `age_range` column..." do
      JquestPg::Mandature.eager_load(:person, :legislature).find_each do |mandature|
        mandature.update_attribute :age_range, mandature.get_age_range
      end
    end
  end

  def down
    remove_column :jquest_pg_mandatures, :age_range
  end
end
