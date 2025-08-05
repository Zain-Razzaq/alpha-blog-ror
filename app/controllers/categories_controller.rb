# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :require_admin, only: %i[new create destroy]
  before_action :set_category, only: %i[show destroy]

  def index
    @categories = Category.all
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Category deleted successfully.'
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    return if user_logged_in? && current_user.admin?

    flash[:alert] = "You don't have permission to perform this action."
    redirect_to categories_path
  end
end
