class ChangeJquestPgPeopleBirthdateToDate < ActiveRecord::Migration[5.0]
  def change
    case connection.adapter_name.downcase.to_sym
    when :sqlite
      change_column :jquest_pg_people, :birthdate, :date
    when :postgresql
      change_column :jquest_pg_people, :birthdate, "date USING to_date(birthdate, 'DD/MM/YYYY')"
    else
      raise NotImplementedError, "Unknown adapter type"
    end
  end
end
