class SearchEntry < ApplicationRecord
  belongs_to :searchable, polymorphic: true
  delegated_type :searchable, types: %w[ Post User Group Friendship ]

  validates :searchable_type, uniqueness: { scope: :searchable_id }
end
