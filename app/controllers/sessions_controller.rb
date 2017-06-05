class SessionsController < ApplicationController

  def new
    #debugger
  end

  # creates session hash w/ form when user signs in
  def create 
  	@user = User.find_by(email: params[:session][:email].downcase)

  	if @user && @user.authenticate(params[:session][:password])
  		log_in @user #app/helpers/session_helper.rb
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  		redirect_back_or @user #see session helper for this method
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end
