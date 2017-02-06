class CreateJquestPgPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :jquest_pg_people do |t|
      t.string :fullname
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :education
      t.string :profession_category
      t.string :profession
      t.string :image
      t.string :twitter
      t.string :facebook
      t.string :gender
      t.string :birthdate
      t.string :birthplace
      t.string :phone

      t.timestamps null: false
    end
  end
end
