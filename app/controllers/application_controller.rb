# frozen_string_literal: true

#  Base class for controllers
class ApplicationController < ActionController::Base
  #  Declaring these methods here makes them availabl eto all controllers
  #  BUT:  We also need them to be available to Views, that is what "helper_method" does

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    if current_user
      true
    else
      false
    end
  end

  # A knowledgeable user that is not logged in could still create an article by entering the
  # /new url in the addreess bar.
  # To trap that, this check is here so that controllers can require a user be defined before
  # allowing further access to their functions.
  def require_user
    return if logged_in?

    flash[:warning] = 'You must be logged in to perform that action.'
    redirect_to login_path
  end
end
