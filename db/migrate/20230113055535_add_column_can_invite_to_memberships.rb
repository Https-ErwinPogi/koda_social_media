class AddColumnCanInviteToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :can_invite, :boolean
  end
end
