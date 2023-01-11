class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.integer :privacy
      t.string :banner
      t.string :name
      t.string :description
      t.references :user
      t.timestamps
    end
  end
end
