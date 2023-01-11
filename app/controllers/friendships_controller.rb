class FriendshipsController < ApplicationController
  before_action :set_friend, only: :destroy
  before_action :show_friend, only: :show

  def index
    @friends = current_user.friends
  end

  def show; end

  def destroy
    current_user.friends.destroy(@friend)
    flash[:notice] = "User #{@friend.username} has been removed from friend lists"
    redirect_to friendships_path
  end

  private

  def set_friend
    @friend = current_user.friends.find(params[:id])
  end

  def show_friend
    @friend = current_user.friends.find_by(params[:friend_id])
  end
end
