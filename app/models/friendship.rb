class Friendship < ApplicationRecord
  include Searchable
  after_commit :create_search_entry, on: :create
  after_commit :update_search_entry, on: :update
  after_commit :destroy_search_entry, on: :destroy
  after_create :create_inverse_relationship
  after_destroy :destroy_inverse_relationship
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  validates :user, presence: true
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self

  private

  def create_inverse_relationship
    friend.friendships.create(friend: user)
  end

  def destroy_inverse_relationship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

  def create_search_entry
    SearchEntry.create(image: self.user.email, name: self.user.username, body: self.user_id, searchable: self)
  end

  def update_search_entry
    self.search_entry.update(image: self.user.email, name: self.user.username, body: self.user_id) if self.search_entry.present?
  end

  def destroy_search_entry
    self.search_entry.destroy if self.search_entry.present?
  end
end
