class FriendRequestsController < ApplicationController
  before_action :set_friend_request, except: [:index, :create]

  def index
    @incoming = FriendRequest.where(friend: current_user)
    @outgoing = current_user.friend_requests
    @friends = current_user.friends.pluck(:friend_id)
    @find_friends = User.where.not(id: @friends).where("id != ?", current_user.id)
    @pluck = current_user.friend_requests.where(user_id: @friends)
  end

  def create
    friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.new(friend: friend)
    if @friend_request.save
      flash[:notice] = "#{@friend_request.friend.username} has been added to your friend request list"
      redirect_to friend_requests_path
    else
      flash[:alert] = @friend_request.errors.full_messages.join(", ")
      redirect_to friend_requests_path
    end
  end

  def update
    @friend_request.accept
    flash[:notice] = "You are now friends with #{@friend_request.friend.username}"
    redirect_to friend_requests_path
  end

  def destroy
    @friend_request.destroy
    flash[:alert] = "You cancelled your friend request with user #{@friend_request.friend.username}"
    redirect_to friend_requests_path
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
