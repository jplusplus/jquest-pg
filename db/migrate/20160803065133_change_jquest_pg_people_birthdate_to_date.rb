class ChangeJquestPgPeopleBirthdateToDate < ActiveRecord::Migration
  def change
    change_column :jquest_pg_people, :birthdate, "date USING to_date(birthdate, 'DD/MM/YYYY')"
  end
end
