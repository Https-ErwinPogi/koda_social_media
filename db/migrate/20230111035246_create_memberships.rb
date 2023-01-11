class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.integer :role
      t.boolean :is_owner, default: 0
      t.references :user
      t.references :group
      t.timestamps
    end
  end
end
