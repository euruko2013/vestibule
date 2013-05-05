class User < ActiveRecord::Base
  has_many :proposals, :foreign_key => :proposer_id
  has_many :suggestions, :foreign_key => :author_id
  has_many :proposals_of_interest, :through => :suggestions, :source => :proposal, :uniq => true
  has_many :selections, order: :position
  has_many :selected_proposals, :through => :selections, :source => :proposal

  acts_as_voter
  has_karma(:proposals, :as => :proposer)

  scope :with_signup_reasons, where("signup_reason IS NOT NULL")
  scope :without_signup_reasons, where(:signup_reason => nil)

  attr_accessible :signup_reason,
                  :subscribe_to_suggestions_notifications,
                  :publish_selections

  def proposals_you_should_look_at
    Proposal.active.without_suggestions_from(self).without_votes_from(self).not_proposed_by(self)
  end

  def proposals_without_own_votes
    Proposal.active.without_votes_from(self).not_proposed_by(self)
  end

  def proposals_that_have_changed
    proposals_of_interest.active.not_proposed_by(self).includes(:suggestions).select { |p| p.updated_at > p.suggestions.by(self).maximum(:updated_at) }
  end

  def proposals_that_have_been_withdrawn
    proposals_of_interest.withdrawn
  end

  def self.create_with_omniauth(auth)
    auth = auth.with_indifferent_access

    create! do |user|
      user.name = auth[:info][:name] || auth[:info][:nickname]
      user.send(:"#{auth[:provider]}_uid=", auth[:uid])
      user.send(:"#{auth[:provider]}_nickname=", auth[:info][:nickname])
      user.email = auth[:info][:email]
    end
  end

  def self.find_or_create_with_omniauth(auth)
    auth = auth.with_indifferent_access

    (auth[:info] && auth[:info][:email].present? ? self.find_by_email(auth[:info][:email]) : nil) ||
        self.send("find_by_#{auth[:provider]}_uid", auth[:uid]) ||
        self.create_with_omniauth(auth)
  end

  def update_provider_details(auth)
    auth = auth.with_indifferent_access

    self.send(:"#{auth[:provider]}_uid=", auth[:uid]) if self.send(:"#{auth[:provider]}_uid").blank?
    self.send(:"#{auth[:provider]}_nickname=", auth[:info][:nickname]) if self.send(:"#{auth[:provider]}_nickname").blank?
    self.save
  end

  def  update_last_visit
    self.last_visited_at = DateTime.now
    self.save!
  end

  def proposals_with_interest
    proposals.select { |p| p.suggestions.any? }
  end

  def add_selections(proposal_ids)
    transaction do
      selections.destroy_all
      self.selections = Array(proposal_ids).each_with_index.map do |proposal_id, index|
        selections.create! do |s|
          s.proposal_id = proposal_id
          s.position = index + 1
        end
      end
    end
  end

  # Max score: 5
  def update_contribution_score!
    self.contribution_score =
        # Thorough reading of the actual proposals before voting
        (number_of_proposals_seen_before_phase_two.to_f / Proposal.count) + # Max: 1
        (number_of_nominated_proposals_seen_during_phase_two.to_f / Proposal.where(:nominated => true).count) + # Max: 1
        # Interaction with proposal authors
        (number_of_proposals_discussed.to_f / Proposal.count) + # Max: 1
        # No hit & run votes/selections
        (number_of_proposals_voted.to_f / Proposal.count) + # Max: 1
        (number_of_proposals_selected.to_f / Proposal.where(:nominated => true).count) # Max: 1
    self.save!
    self.contribution_score
  end

  ### ACL Stuff ###

  def moderator?
    self.committee_member?
  end

  def committee_member?
    self.email.present? && self.email =~ /@euruko2013\.org$/
  end

  #######
  private
  #######

  def number_of_proposals_seen_before_phase_two
    Impression.
        where(:user_id => self.id, :impressionable_type => 'Proposal').
        where('created_at < ?', Phase::TWO.starting_at).
        count(:impressionable_id, :distinct => true)
  end

  def number_of_nominated_proposals_seen_during_phase_two
    Impression.
        where(:user_id => self.id, :impressionable_type => 'Proposal', :impressionable_id => Proposal.where(:nominated => true).pluck(:id)).
        where('created_at > ?', Phase::TWO.starting_at).
        where('created_at < ?', Phase::TWO.ending_at).
        count(:impressionable_id, :distinct => true)
  end

  def number_of_proposals_discussed
    suggestions.not_on_proposals_by(self).count(:proposal_id, :distinct => true)
  end

  def number_of_proposals_voted
    Vote.where(:voter_id => self.id).count
  end

  def number_of_proposals_selected
    selections.count
  end
end
