class CreateJquestPgDiversities < ActiveRecord::Migration
  def change
    create_table :jquest_pg_diversities do |t|
      # All action are relation to a user AND a season
      t.references :resource_a, polymorphic: true
      t.references :resource_b, polymorphic: true
      # Type of the resource this comparaison
      t.string :resource_a_type
      t.string :resource_b_type
      # Value of the diversity comparaison
      #  1 if a > b
      # -1 if a < b
      t.integer :value

      t.timestamps null: false
    end
  end
end
