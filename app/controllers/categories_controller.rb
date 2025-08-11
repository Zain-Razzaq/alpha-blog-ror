# frozen_string_literal: true

class CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token


  before_action :require_admin, only: %i[new create destroy]
  before_action :set_category, only: %i[show destroy]

  def index
    @categories = Category.all
    render json: @categories
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    begin
      @category = Category.new(category_params)
      if @category.save
        render json: @category, status: :created
      else
        render json: { message: @category.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { message: @category.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      if @category.destroy
        render json: { message: 'Category was successfully deleted.' }, status: :ok
      else
        render json: { message: @category.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue => e
      render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def category_params
    params.permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    return if user_logged_in? && current_user.admin?
    render json: { message: current_user }, status: :forbidden
  end
end
