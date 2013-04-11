class DashboardController < ApplicationController
  def index
    authorize! :see, :dashboard

    @your_proposals = current_user.proposals
    @proposals_you_should_look_at = current_user.proposals_you_should_look_at
    @proposals_that_have_changed = current_user.proposals_that_have_changed
    @proposals_that_have_been_withdrawn = current_user.proposals_that_have_been_withdrawn

    @submissions_start = DateTime.parse(Settings.submissions_start).to_date

    if can? :see, :moderator_dashboard
      @proposals = Proposal.where("updated_at > ? ", @submissions_start)
      @suggestions = Suggestion.where("created_at > ? ", @submissions_start)
      @users = User.where("created_at > ?", @submissions_start)
      @impressions = Impression.where("created_at > ?", @submissions_start)
      @upvotes = Vote.where(:vote => true).where("created_at > ?", @submissions_start)
      @downvotes = Vote.where(:vote => false).where("created_at > ?", @submissions_start)
    end
  end
end