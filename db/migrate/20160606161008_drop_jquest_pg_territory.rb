class DropTerritory < ActiveRecord::Migration
  def change
    drop_table :jquest_pg_territories
  end
end
