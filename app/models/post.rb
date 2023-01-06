class Post < ApplicationRecord
  validates :content, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :user
  enum audience: { post_public: 0, only_friend: 1, post_private: 2 }
end
