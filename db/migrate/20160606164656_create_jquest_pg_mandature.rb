class CreateJquestPgMandature < ActiveRecord::Migration[5.0]
  def change
    create_table :jquest_pg_mandatures do |t|
      t.references :legislature, index: true, foreign_key: {:to_table  => :jquest_pg_legislatures}
      t.references :person, index: true, foreign_key: {:to_table  => :jquest_pg_people}
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
