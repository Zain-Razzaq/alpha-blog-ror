# frozen_string_literal: true

class BlogsController < ApplicationController
  skip_before_action :verify_authenticity_token


  before_action :set_blog, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :require_owner, only: %i[edit update destroy]

  def index
    begin 
      @blogs = Blog.includes(:user).includes(:categories).all
      render json: @blogs.as_json(include: { user: { only: [:id, :name, :email] }, categories: { only: [:id, :name] } })
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end
   
  end

  def show
    begin
      render json: @blog.as_json(include: { user: { only: [:id, :name, :email] }, categories: { only: [:id, :name] } })
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end


  def create
    begin 
      @blog = Blog.new(blog_params)
      @blog.user = current_user
      if @blog.save
        render json: @blog.as_json(include: { user: { only: [:id, :name, :email] } }), status: :created
      else
        render json: { message: @blog.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  def edit; end

  def update
    begin
      if @blog.update(blog_params)
        render json: @blog.as_json(include: { user: { only: [:id, :name, :email] } }), status: :ok
      else
        render json: { message: @blog.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  def destroy
    begin
      @blog.destroy
      if @blog.destroyed?
        render json: { message: 'Blog deleted successfully' }, status: :ok
      else
        render json: { message: 'Failed to delete blog' }, status: :unprocessable_entity
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  def delete_last
    DeleteLastBlogJob.perform_later
    redirect_to blogs_path, notice: 'Last blog deleted.'
  end

  private

  # def set_blog
  #   @blog = Blog.includes(:user).find_by(id: params[:id])
  # end
  
  def set_blog
    @blog = Blog.includes(:user).includes(:categories).find_by(id: params[:id])
    render json: { message: "Blog not found" }, status: :not_found unless @blog
  end

  def blog_params
    params.permit(:title, :content, category_ids: [])
  end

  def require_owner
    return if user_logged_in? && (current_user == @blog.user || current_user.admin?)
    render json: { message: 'You are not authorized to perform this action' }, status: :forbidden
  end
end
