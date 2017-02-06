class ChangeDiversitiesValues < ActiveRecord::Migration[5.0]
  def up
    # Migrate data
    JquestPg::Diversity.where(value: -1).update_all(value: 0)
  end

  def down
    # Migrate data
    JquestPg::Diversity.where(value: 0).update_all(value: -1)
  end
end
