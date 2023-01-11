class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      @group_member = current_user.memberships.new(user_id: current_user, group: @group, is_owner: true, role: :admin)
      @group_member.save
      flash[:notice] = "Group has been successfully created"
      redirect_to groups_path
    else
      render :new
    end
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

  private

  def group_params
    params.require(:group).permit(:name, :banner, :description, :privacy)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
