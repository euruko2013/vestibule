class SuggestionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @suggestion = current_user.suggestions.build(params[:suggestion].merge(:proposal => @proposal))
    if @suggestion.save
      SuggestionsMailer.new_suggestion(@suggestion).deliver 
      redirect_to proposal_path(@proposal)
    else
      render :template => 'proposals/show'
    end
  end
end