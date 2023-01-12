class MembershipsController < ApplicationController
  before_action :set_group, only: :create

  def create
    is_already_joined = current_user.memberships.where(group_id: params[:group_id]).blank?
    if is_already_joined
      @join_group = Membership.new(group_id: params[:group_id])
      @join_group.user = current_user
      @join_group.role = :normal
      @join_group.save
      redirect_to groups_path
      flash[:notice] = 'Join Group!'
    else
      redirect_to groups_path
      flash[:alert] = "You are already joined in the group!"
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end