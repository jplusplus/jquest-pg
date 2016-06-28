class CreateJquestPgDiversities < ActiveRecord::Migration
  def change
    create_table :jquest_pg_diversities do |t|
      # All action are relation to a user AND a season
      t.references :resource_a, index: true, foreign_key: true
      t.references :resource_b, index: true, foreign_key: true
      # Type of the resources we compare
      t.string :type
      # Value of the diversity comparaison
      #  1 if a > b
      # -1 if a < b
      t.integer :value

      t.timestamps null: false
    end
  end
end
