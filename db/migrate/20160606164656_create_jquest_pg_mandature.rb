class CreateJquestPgMandature < ActiveRecord::Migration
  def change
    create_table :jquest_pg_mandatures do |t|
      t.references :jquest_pg_legislature, index: true, foreign_key: true
      t.references :jquest_pg_person, index: true, foreign_key: true
      t.string :political_leaning
      t.string :role
      t.string :group
      t.string :area
      t.string :chamber
      t.timestamps null: false
    end
    add_index :jquest_pg_mandatures, [:legislature_id, :person_id], :unique => true
  end
end
