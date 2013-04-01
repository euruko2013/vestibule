class DashboardController < ApplicationController
  def index
    authorize! :see, :dashboard

    @your_proposals = current_user.proposals
    @proposals_you_should_look_at = current_user.proposals_you_should_look_at
    @proposals_that_have_changed = current_user.proposals_that_have_changed
    @proposals_that_have_been_withdrawn = current_user.proposals_that_have_been_withdrawn

    if can? :see, :moderator_dashboard
      last_visited_at = current_user.last_visited_at || DateTime.new(1970, 01, 01)
      @proposals_since_last_login = Proposal.where("updated_at > ? ", last_visited_at)
      @suggestions_since_last_login = Suggestion.where("created_at > ? ", last_visited_at)
    end
  end
end