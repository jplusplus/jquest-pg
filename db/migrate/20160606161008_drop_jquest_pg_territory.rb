class DropJquestPgTerritory < ActiveRecord::Migration[5.0]
  def change
    drop_table :jquest_pg_territories
  end
end
