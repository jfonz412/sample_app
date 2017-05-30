class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		#debugger
	end

  def new
  	@user = User.new
  	#debugger
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		#handle successful save
  	else
  		render 'new'
  	end
  end
end
