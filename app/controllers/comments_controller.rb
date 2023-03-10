class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @post.comments
  end

  def new
    @comment = @post.comments.build
  end

  def create
    @comment = @post.comments.build(params_comment)
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(params[:post_id])
      flash[:notice] = "Comment successfully created"
    else
      render :new
    end
  end

  def edit
    authorize @comment, :edit?, policy_class: CommentPolicy
  end

  def update
    authorize @comment, :update?, policy_class: CommentPolicy
    if @comment.update(params_comment)
      redirect_to post_path(params[:post_id])
      flash[:notice] = "Comment successfully updated"
    else
      render :edit
    end
  end

  def destroy
    authorize @comment, :destroy?, policy_class: CommentPolicy
    @comment.destroy
    redirect_to post_path(params[:post_id])
    flash[:notice] = "Comment successfully deleted"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def params_comment
    params.require(:comment).permit(:content).merge(post_id: params[:post_id])
  end
end
