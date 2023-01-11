class Group < ApplicationRecord
  validates :name, :privacy, :description, :banner, presence: true
  belongs_to :user
  has_many :memberships
  mount_uploader :banner, ImageUploader
  enum privacy: { community: 0, hidden: 1 }
end
