class AddColumnStateToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :state, :string
  end
end
