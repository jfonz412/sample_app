class Micropost < ApplicationRecord
  belongs_to :user
  # set default order to pull up most recent posts first
  default_scope -> { order(created_at: :desc) }
  # Tells Carrier wave gem to associate image with model
  mount_uploader :picture, PictureUploader #rails method, args = attribute + generated uploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
