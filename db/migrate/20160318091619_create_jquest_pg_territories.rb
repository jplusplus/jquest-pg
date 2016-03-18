class CreateJquestPgTerritories < ActiveRecord::Migration
  def change
    create_table :jquest_pg_territories do |t|
      t.string :name
      t.string :country

      t.timestamps
    end
  end
end
