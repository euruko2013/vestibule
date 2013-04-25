class DashboardController < ApplicationController
  def index
    authorize! :see, :dashboard

    @your_proposals = current_user.proposals.includes(:suggestions)

    if current_phase.new_submissions_allowed? || current_phase.submission_editing_allowed?
      @proposals_you_should_look_at = current_user.proposals_you_should_look_at.includes(:suggestions).limit(5)
    end

    if current_phase.submission_editing_allowed?
      @proposals_that_have_changed = current_user.proposals_that_have_changed
    end

    if current_phase.voting_allowed?
      @unvoted_proposals = current_user.proposals_without_own_votes.includes(:suggestions).limit(20)
    end

    if current_phase.submission_withdrawal_allowed?
      @proposals_that_have_been_withdrawn = current_user.proposals_that_have_been_withdrawn.includes(:suggestions)
    end
  end
end