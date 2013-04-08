class DashboardController < ApplicationController
  def index
    authorize! :see, :dashboard

    @your_proposals = current_user.proposals
    @proposals_you_should_look_at = current_user.proposals_you_should_look_at
    @proposals_that_have_changed = current_user.proposals_that_have_changed
    @proposals_that_have_been_withdrawn = current_user.proposals_that_have_been_withdrawn

    if can? :see, :moderator_dashboard
      last_visited_at = current_user.last_visited_at || DateTime.new(1970, 01, 01)
      show_proposals_since = session[:dashboard_info_since] || last_visited_at

      @proposals_since_selected_time = Proposal.where("updated_at > ? ", show_proposals_since)
      @suggestions_since_selected_time = Suggestion.where("created_at > ? ", show_proposals_since)
      @users_since_selected_time = User.where("created_at > ?", show_proposals_since)
    end
  end
end