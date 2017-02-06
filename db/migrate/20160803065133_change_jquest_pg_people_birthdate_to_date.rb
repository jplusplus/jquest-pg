class ChangeJquestPgPeopleBirthdateToDate < ActiveRecord::Migration[5.0]
  def change
    change_column :jquest_pg_people, :birthdate, :date
  end
end
