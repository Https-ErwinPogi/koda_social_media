class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    group_ids = current_user.memberships.where.not(state: [:decline, :leave]).pluck(:group_id)
    @groups = current_user.groups.where.not(id: group_ids)
    @groups = current_user.groups.where(user: current_user)
    @joined_groups = Membership.where(user: current_user).where(state: :approved).where.not(role: :admin).includes(:user, :group)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      @group_member = current_user.memberships.new(user_id: current_user, group: @group, role: :admin, is_owner: true, state: :approved)
      @group_member.save
      flash[:notice] = "Group has been successfully created"
      redirect_to groups_path
    else
      render :new
    end
  end

  def show
    @members = Membership.approved.where(group: @group).count
  end

  def edit
    authorize @group, :edit?, policy_class: GroupPolicy
  end

  def update
    authorize @group, :update?, policy_class: GroupPolicy
    if @group.update(group_params)
      flash[:notice] = "Group has been edited"
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    authorize @group, :destroy?, policy_class: GroupPolicy
    @group.destroy
    flash[:notice] = "Group has been deleted"
    redirect_to groups_path
  end

  def members
    @join_groups = Membership.includes(:user, :group).where(group_id: set_join_group)
    @current_members = @join_groups.where.not(state: :requesting)
    # @sent_requests = @join_groups.where(user: current_user).requesting
    @received_requests = @join_groups.requesting
    # @can_invite = current_user.memberships.where(group: @group).where(can_invite: 1).present? == true
    @user_friends = current_user.friends.where.not(id: @group.memberships.where(state: :approved).pluck(:user_id))
  end

  def invite
    invite_friend = Membership.where(group_id: params[:group_id]).where(user: params[:user_id]).blank?
    if invite_friend
      @join_group = Membership.new(group_id: params[:group_id], user_id: params[:user_id], role: :normal, state: :approved)
      if @join_group.save
        redirect_to groups_path
        flash[:notice] = "Added to group!"
      else
        flash[:alert] = @join_group.errors.full_messages.join(", ")
        redirect_to groups_path
      end
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :banner, :description, :privacy, :can_invite)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def set_join_group
    @group = Group.find(params[:group_id])
  end
end
