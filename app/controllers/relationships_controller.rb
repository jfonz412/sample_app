class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		user = User.find(params[:followed_id])
		current_user.follow(user)
		redirect_to user
	end

	def destroy
		user = Relationship.find(params[:id]).followed # user = the one being followed in this relationship
		current_user.unfollow(user)
		redirect_to user
	end
end
