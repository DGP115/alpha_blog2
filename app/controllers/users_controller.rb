# frozen_string_literal: true

# Class for users controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_same_user, only: %i[edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelist_params)
    if @user.save
      # Log the succesfully-created user into the app
      session[:user_id] = @user.id
      # Use flash helper to display feedback message
      flash[:notice] = "Welcome #{@user.username.capitalize}"
      redirect_to articles_path
    else
      # The saving of the new user has failed, so:
      # 1:  re-render the new form on which we loop through the
      #     error messages associated with the attempt to save the new user
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    # Get the articles authored by this user
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
                     .order(created_at: :desc)
  end

  def edit; end

  def index
    @users = User.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def destroy
    if @user.delete
      #  Log the deleted user out only if they initiated the account deletion.
      #  [Since admin users can delete accounts for other users]
      session[:user_id] = nil if @user == current_user
      #  Use flash helper to display feedback message
      flash[:notice] = 'User profile successfully deleted'
      redirect_to articles_path
    else
      # The deletion of the user has failed, so:
      # 1:  re-render the show form on which we loop through the
      #     error messages associated with the attempt to delete the user
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'show', status: :unprocessable_entity
    end
  end

  def update
    if @user.update(whitelist_params)
      #  Use flash helper to display feedback message
      flash[:notice] = 'User profile successfully updated'
      redirect_to users_path(@user)
    else
      # The update of the user has failed, so:
      # 1:  re-render the form on which we loop through the
      #     error messages associated with the attempt to update the user record.
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def whitelist_params
    params.require(:user).permit(:username, :email_address, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    return if current_user == @user || current_user.admin

    flash[:warning] = 'You can only alter your own profile'
    redirect_to user_path(@user)
  end
end
