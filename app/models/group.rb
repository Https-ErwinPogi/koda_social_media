class Group < ApplicationRecord
  include Searchable
  after_commit :create_search_entry, on: :create
  after_commit :update_search_entry, on: :update
  after_commit :destroy_search_entry, on: :destroy
  validates :name, :privacy, :description, :banner, presence: true
  belongs_to :user
  has_many :memberships
  mount_uploader :banner, ImageUploader
  enum privacy: { community: 0, hidden: 1 }

  private

  def create_search_entry
    SearchEntry.create(image: self.banner, name: self.name, body: self.description, searchable: self)
  end

  def update_search_entry
    self.search_entry.update(image: self.banner, name: self.name, body: self.description) if self.search_entry.present?
  end

  def destroy_search_entry
    self.search_entry.destroy if self.search_entry.present?
  end
end
