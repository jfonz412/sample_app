class Relationship < ApplicationRecord
	belongs_to :follower, class_name: "User" #has a follower_id column, which is a User
	belongs_to :followed, class_name: "User" #has a followed_id column, which is a User
	
	validates  :follower_id, presence: true
	validates  :followed_id, presence: true
end
