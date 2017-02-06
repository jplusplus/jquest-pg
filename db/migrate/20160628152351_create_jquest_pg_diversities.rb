class CreateJquestPgDiversities < ActiveRecord::Migration[5.0]
  def change
    create_table :jquest_pg_diversities do |t|
      # All action are relation to a user AND a season
      t.references :resource_a, polymorphic: true, index: false
      t.references :resource_b, polymorphic: true, index: false
      # Type of the resource this comparaison
      t.string :resource_a_type
      t.string :resource_b_type
      # Value of the diversity comparaison
      #  1 if a > b
      # -1 if a < b
      t.integer :value

      t.timestamps null: false
    end
    # Manualy create indexes to set custom names
    add_index :jquest_pg_diversities, [:resource_a_type, :resource_a_id], :name => :index_pg_diversities_on_resource_a_type_and_resource_a_id
    add_index :jquest_pg_diversities, [:resource_b_type, :resource_b_id], :name => :index_pg_diversities_on_resource_b_type_and_resource_b_id
  end
end
