# frozen_string_literal: true

class BlogsController < ApplicationController
  before_action :set_blog, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :require_owner, only: %i[edit update destroy]

  def index
    @blogs = Blog.all
  end

  def show; end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user
    if @blog.save
      redirect_to @blog, notice: 'Blog was successfully created.'
    else
      redirect_to new_blog_path, alert: 'Error creating blog.'
    end
  end

  def edit; end

  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: 'Blog was successfully updated.'
    else
      redirect_to edit_blog_path(@blog), alert: @blog.errors.full_messages.to_sentence
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_url, notice: 'Blog was successfully destroyed.'
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end

  def require_owner
    return if user_logged_in? && (current_user == @blog.user || current_user.admin?)

    flash[:alert] = "You don't have permission to perform this action."
    redirect_to blogs_path
  end
end
