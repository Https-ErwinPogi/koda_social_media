class Post < ApplicationRecord
  include Searchable
  after_commit :create_search_entry, on: :create
  after_commit :update_search_entry, on: :update
  after_commit :destroy_search_entry, on: :destroy
  validates :content, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :comments
  enum audience: { post_public: 0, only_friend: 1, post_private: 2 }

  private

  def create_search_entry
    SearchEntry.create(image: self.image, name: self.user.username, body: self.content, searchable: self)
  end

  def update_search_entry
    self.search_entry.update(image: self.image, name: self.user.username, body: self.content) if self.search_entry.present?
  end

  def destroy_search_entry
    self.search_entry.destroy if self.search_entry.present?
  end
end