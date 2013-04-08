class DashboardController < ApplicationController
  def index
    authorize! :see, :dashboard

    @your_proposals = current_user.proposals
    @proposals_you_should_look_at = current_user.proposals_you_should_look_at
    @proposals_that_have_changed = current_user.proposals_that_have_changed
    @proposals_that_have_been_withdrawn = current_user.proposals_that_have_been_withdrawn

    if can? :see, :moderator_dashboard

      @epoch = DateTime.new(1970, 1, 1)
      @now = DateTime.now

      last_visited_at = current_user.last_visited_at || @epoch

      @selected_time_code = case
                              when params[:dashboard].present?
                                params[:dashboard][:selected_time]
                              when session[:selected_time_code].present?
                                session[:selected_time_code]
                              else
                                'epoch'
                            end

      session[:selected_time_code] = @selected_time_code

      @selected_time = case @selected_time_code
                         when 'last_login'
                           last_visited_at
                         when 'this_month'
                           DateTime.new(@now.year, @now.month, 1)
                         when 'epoch'
                           @epoch
                         else
                           last_visited_at
                       end

      @proposals_since_selected_time = Proposal.where("updated_at > ? ", @selected_time)
      @suggestions_since_selected_time = Suggestion.where("created_at > ? ", @selected_time)
      @users_since_selected_time = User.where("created_at > ?", @selected_time)
      @logins_since_selected_time = User.where("last_visited_at > ?", @selected_time)

      @time_options = [
          ['last_login',  'Since my last login'],
          ['this_month', 'This Month'],
          ['epoch', 'Everything']
      ]
    end
  end
end