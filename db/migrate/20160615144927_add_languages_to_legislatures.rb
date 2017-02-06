class AddLanguagesToLegislatures < ActiveRecord::Migration[5.0]
  def change
    add_column :jquest_pg_legislatures, :languages, :string
  end
end
