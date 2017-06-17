class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		# only one of these lines will run, in this case the js line because we enables Ajax
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed # user = the one being followed in this relationship
		current_user.unfollow(@user)
		# continued from above, this gives us an alternaitve if js is diabled in a browser
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
	end
end
