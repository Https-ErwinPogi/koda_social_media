class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:user).order(id: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if Rails.env.development?
      @post.location = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
      @post.location = Geocoder.search(@post.location).first.city
    else
      @post.location = request.remote_ip
    end
    if @post.save
      flash[:notice] = "Post was successfully saved"
      redirect_to posts_path
    else
      render :new
    end
  end

  def show; end

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
      flash[:notice] = "Post successfully updated"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    @post.destroy
    flash[:notice] = "Post successfully deleted"
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image, :content, :audience, :location)
  end
end
