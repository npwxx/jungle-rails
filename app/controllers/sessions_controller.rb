class SessionsController < ApplicationController

  def create
    if user = User.authenticate_with_credentials(email: params[:email], password: params[:password])
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end