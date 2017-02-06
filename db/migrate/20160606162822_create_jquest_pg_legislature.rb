class CreateJquestPgLegislature < ActiveRecord::Migration[5.0]
  def change
    create_table :jquest_pg_legislatures do |t|
      t.string :name
      t.string :name_english
      t.string :name_local
      t.string :territory
      t.integer :difficulty_level
      t.string :country, :limit => 3
      t.date :start_date
      t.date :end_date
      t.string :source
      t.string :list
      t.integer :number_of_members

      t.timestamps null: false
    end
  end
end
