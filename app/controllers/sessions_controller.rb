class SessionsController < ApplicationController

  def new
  end

  # creates session hash w/ form when user signs in
  def create 
  	user = User.find_by(email: params[:session][:email].downcase)

  	if user && user.authenticate(params[:session][:password])
  		log_in user #app/helpers/session_helper.rb
      remember user
  		redirect_to user
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end
end
