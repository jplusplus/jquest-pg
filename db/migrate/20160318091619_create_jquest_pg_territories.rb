class CreateJquestPgTerritories < ActiveRecord::Migration[5.0]
  def change
    create_table :jquest_pg_territories do |t|
      t.string :name
      t.string :country

      t.timestamps
    end
  end

  add_index :users, :uid
end
