class AddLanguagesToLegislatures < ActiveRecord::Migration
  def change
    add_column :jquest_pg_legislatures, :languages, :string
  end
end
