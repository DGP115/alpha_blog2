# frozen_string_literal: true

# Class for article Categories controller
class CategoriesController < ApplicationController
  before_action :require_admin_user, except: %i[index show]
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5).order(name: :asc)
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelist_params)
    if @category.save
      flash[:notice] = "Category #{@category.name} successfully created"
      redirect_to categories_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(whitelist_params)
      #  Use flash helper to display feedback message
      flash[:notice] = 'Category successfully updated'
      redirect_to categories_path
    else
      # The update of the category has failed, so:
      # 1:  re-render the new form on which we loop through the
      #     error messages associated with the attempt to save the category
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @category.delete
      #  Use flash helper to display feedback message
      flash[:notice] = "Category #{@category.name} successfully deleted"
      redirect_to categories_path
    else
      # The deletion of the category has failed, so:
      # 1:  re-render the show form on which we loop through the
      #     error messages
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'show', status: :unprocessable_entity
    end
  end

  private

  def whitelist_params
    params.require(:category).permit(:name)
  end

  def require_admin_user
    if logged_in? && current_user.admin
      true
    else
      flash[:warning] = 'You must be an admin user to alter categories'
      redirect_to categories_path
    end
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
