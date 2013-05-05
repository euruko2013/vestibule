require 'statistics2'

class Proposal < ActiveRecord::Base
  belongs_to :proposer, :class_name => 'User'
  has_many :suggestions
  has_many :selections

  has_paper_trail
  acts_as_voteable

  validates :title, :presence => true

  # This allows us to do @proposal.impression_count
  # and other stuff from the 'impressionist' gem.
  is_impressionable counter_cache: { column_name: :impressions_counter_cache }

  scope :without_suggestions_from, lambda { |user|
    if user.suggestions.any?
      where('id NOT IN (?)', user.suggestions.map{ |s| s.proposal_id }.uniq)
    end
  }

  scope :without_votes_from, lambda { |user|
    voted_by_user = user.votes.where(voteable_type: 'Proposal')
    if voted_by_user.any?
      where('id NOT IN (?)', voted_by_user.map{ |s| s.voteable_id }.uniq)
    end
  }

  scope :not_proposed_by, lambda { |user|
    where('proposer_id != ?', user.id)
  }

  scope :active, where(withdrawn: false)
  scope :withdrawn, where(withdrawn: true)

  after_create :update_proposer_score

  class << self
    def update_phase_one_stats!
      transaction do
        all.each { |v| v.update_phase_one_stats! }
      end
    end

    def rank_phase_one!
      transaction do
        self.order('total_wilson_score DESC').each_with_index do |proposal, index|
          proposal.phase_one_ranking = index + 1
          proposal.save!
        end
      end
    end

    def nominate!
      nominated_ids =
          self.active.order(:phase_one_ranking).to_a.
              uniq { |p| p.proposer_id }.
              take(30).
              map { |p| p.id }

      transaction do
        self.update_all('nominated = false')
        self.update_all('nominated = true', ['id IN (?)', nominated_ids])
      end
    end
  end

  def last_modified
    new_suggestions.any? ? new_suggestions.maximum(:updated_at) : last_modified_by_proposer
  end

  def proposed_by?(user)
    proposer == user
  end

  def new_suggestions
    suggestions.after(last_modified_by_proposer)
  end

  def published?
    !withdrawn
  end

  def withdraw!
    update_attribute(:withdrawn, true)
  end

  def republish!
    update_attribute(:withdrawn, false)
  end

  def update_phase_one_stats!
    self.counted_impressions = unique_impressions_by_unique_users
    self.counted_votes_for = votes_without_bad_users.select { |v| v.vote == true }.size
    self.counted_votes_against = votes_without_bad_users.select { |v| v.vote == false }.size
    self.votes_wilson_score = ci_votes
    self.views_wilson_score = ci_views
    self.total_wilson_score = ci_magic
    self.save!
  end





  #######
  private
  #######

  def last_modified_by_proposer
    [suggestions.by(proposer).maximum(:updated_at), updated_at].compact.max
  end

  def update_proposer_score
    proposer.save
  end

  #### Stats calculations ###

  def ci_magic(confidence = 0.95)
    @ci_magic ||= ((ci_votes(confidence) * 0.8) + (ci_views(confidence) * 0.2))
  end

  def ci_votes(confidence = 0.95)
    @ci_votes ||= begin
      v = self.counted_votes_for
      n = self.counted_votes_for + self.counted_votes_against
      if n == 0
        return 0
      end
      z = Statistics2.pnormaldist(1 - (1 - confidence) / 2)
      phat = 1.0 * v / n
      (phat + z * z / (2 * n) - z * Math.sqrt((phat * (1 - phat) + z * z / (4 * n)) / n)) / (1 + z * z / n)
    end
  end

  def ci_views(confidence = 0.95)
    @ci_views ||= begin
      v = self.counted_impressions
      n = Impression.count('user_id', :distinct => true, :conditions => "user_id IS NOT NULL")
      if n == 0
        return 0
      end
      z = Statistics2.pnormaldist(1 - (1 - confidence) / 2)
      phat = 1.0 * v / n
      (phat + z * z / (2 * n) - z * Math.sqrt((phat * (1 - phat) + z * z / (4 * n)) / n)) / (1 + z * z / n)
    end
  end

  # We ignore users who have voted only on one proposal.
  # This _can_ get smarter...
  def votes_without_bad_users
    @votes_without_bad_users ||= votes.reject { |v| Vote.count(:conditions => {'voter_id' => v.voter_id}) < 2 }
  end

  def unique_impressions_by_unique_users
    @unique_impressions_by_unique_users ||= Impression.count('user_id', :distinct => true, :conditions => "user_id IS NOT NULL AND impressionable_id = #{self.id}")
  end
end
