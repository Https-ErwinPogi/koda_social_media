class CreateSearchEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :search_entries do |t|
      t.string :image
      t.string :name
      t.text :body
      t.references :searchable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
