class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum role: { normal: 0, moderator: 1, admin: 2 }
end
