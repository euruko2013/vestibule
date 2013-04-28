class Selection < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal

  validates :position, inclusion: (1..10)
  validates :user, presence: true
  validates :proposal, presence: true
  validates :proposal_id, uniqueness: {scope: :user_id}
  validates :position, uniqueness: {scope: :user_id}

  scope :for_proposal, lambda {|id| where(proposal_id: id) }
end
