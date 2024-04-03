# frozen_string_literal: true

#  Class to manage user sessions
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email_address: params[:session][:email_address].downcase)
    if user
      #  Recall the  authenticate method comes from the bcrypt gem
      if user.authenticate(params[:session][:password])
        #  Rails provides the session isntance vaiable whoich we can use to store something unique
        #  to this user session.  [i.e. So, if need be, our app would remember some user-based
        #  setup until th euser logged out]
        session[:user_id] = user.id
        flash[:notice] = "Welcome #{user.username.titleize}.  You have successfully logged in"
        redirect_to user_path(user)
      else
        flash.now[:warning] = 'The password entered is incorrect.  Try again'
        render 'sessions/new', status: :unprocessable_entity
      end
    else
      flash[:warning] = 'We do not have the entered email address on record.  Try again'
      render 'sessions/new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have successfully logged out'
    redirect_to root_path
  end
end
