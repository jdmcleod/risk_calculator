class SessionsController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]

  def new
    redirect_to calculators_url if logged_in?
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Succesfully logged in! Hi #{user.name}!"
      log_in user
      redirect_to calculators_path
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
