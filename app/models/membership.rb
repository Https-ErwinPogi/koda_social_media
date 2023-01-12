class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum role: { normal: 0, moderator: 1, admin: 2 }

  include AASM

  aasm column: :state do
    state :requesting, initial: true
    state :approved, :cancelled, :declined, :leaved, :removed

    event :approve do
      transitions from: :requesting, to: :approved
    end

    event :cancel do
      transitions from: :requesting, to: :cancelled, after: :delete_record
    end

    event :decline do
      transitions from: :requesting, to: :declined, after: :delete_record
    end

    event :leave do
      transitions from: :approved, to: :leaved, after: :delete_record
    end

    event :remove do
      transitions from: :approved, to: :removed, after: :delete_record
    end

    event :request do
      transitions from: :leaved, to: :requesting
    end
  end

  def delete_record
    Membership.find(self.id).destroy
  end
end
