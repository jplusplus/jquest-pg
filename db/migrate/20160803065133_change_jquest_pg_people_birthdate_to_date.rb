class ChangeJquestPgPeopleBirthdateToDate < ActiveRecord::Migration
  def change
    change_column :jquest_pg_people, :birthdate, :date
  end
end
