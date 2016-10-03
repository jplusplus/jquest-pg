class AddStereotypicalityToPeople < ActiveRecord::Migration[5.0]
  def up
    # Add the new columns
    add_column :jquest_pg_people, :diversity_positive, :integer, default: 0
    add_column :jquest_pg_people, :diversity_count, :integer, default: 0
    # Migrate data to fill this column
    say_with_time "fill `diversity_*` column..." do
      # For every people
      JquestPg::Person.find_each do |person|
        # Update the new fields
        person.update_diversity_fields
      end
    end
  end

  def down
    remove_column :jquest_pg_people, :diversity_positive
    remove_column :jquest_pg_people, :diversity_count
  end
end
