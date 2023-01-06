class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user
      t.string :image
      t.text :content
      t.string :location
      t.integer :audience, default: 0
      t.timestamps
    end
  end
end
