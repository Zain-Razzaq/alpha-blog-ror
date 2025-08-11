# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    begin
      @user = User.find(params[:id])
      if @user
        render json: @user.slice(:id, :name, :email, :admin, :created_at), status: :ok
      else
        render json: { message: 'User not found' }, status: :not_found
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  def user_blogs
    begin
      @user = User.find(params[:id])
      if @user
        @blogs = @user.blogs.includes(:user).includes(:categories).as_json(include: { user: { only: [:id, :name, :email] }, categories: { only: [:id, :name] } })
        render json: @blogs, status: :ok
      else
        render json: { message: 'User not found' }, status: :not_found
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: @user.slice(:id, :name, :email, :admin), status: :created
    else
      render json: {
        message: @user.errors.full_messages.to_sentence
    }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
