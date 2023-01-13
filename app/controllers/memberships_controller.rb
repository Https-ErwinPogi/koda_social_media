class MembershipsController < ApplicationController
  before_action :set_join_group, only: [:approve, :decline]
  before_action :set_group, only: :create

  def create
    is_already_joined = current_user.memberships.where(group_id: params[:group_id]).blank?
    is_hidden = Group.where(id: params[:group_id]).where(privacy: :hidden).present?
    if is_already_joined && is_hidden
      @join_group = Membership.new(group_id: params[:group_id])
      @join_group.user = current_user
      @join_group.role = :normal
      @join_group.save
      redirect_to groups_path
      flash[:notice] = 'Requesting to join!'
    elsif is_already_joined
      @join_group = Membership.new(group_id: params[:group_id])
      @join_group.user = current_user
      @join_group.role = :normal
      @join_group.state = :approved
      @join_group.save
      redirect_to groups_path
      flash[:notice] = 'Join Group!'
    else
      redirect_to groups_path
      flash[:alert] = @join_group.errors.full_messages.join(", ")
    end
  end

  def approve
    if @join_group.may_approve? && @join_group.approve!
      flash[:notice] = "Successfully Approved!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to memberships_path
  end

  def decline
    if @join_group.may_decline? && @join_group.decline!
      flash[:notice] = "Successfully Declined!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to memberships_path
  end

  def cancel
    if @join_group.may_cancel? && @join_group.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to memberships_path
  end

  def leave
    if @join_group.may_leave? && @join_group.leave!
      flash[:notice] = "Successfully Leaved!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to memberships_path
  end

  def remove
    if @join_group.may_remove? && @join_group.remove!
      flash[:notice] = "Successfully Removed!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to memberships_path
  end

  private

  def set_join_group
    @join_group = Membership.find(params[:membership_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end