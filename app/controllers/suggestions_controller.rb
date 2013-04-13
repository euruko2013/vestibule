class SuggestionsController < ApplicationController
  before_filter :fetch_proposal

  def create
    authorize! :read, @proposal

    @suggestion = Suggestion.new(params[:suggestion].merge(:proposal => @proposal, :author => current_user))
    authorize! :create, @suggestion

    if params[:preview]
      render :template => 'proposals/show'
    elsif @suggestion.save
      SuggestionsMailer.new_suggestion(@suggestion).deliver
      redirect_to proposal_path(@proposal), notice: "Your suggestion has been published"
    else
      render :template => 'proposals/show'
    end
  end

  def update
    @suggestion = Suggestion.find params[:id]
    authorize! :update, @suggestion

    if @suggestion.update_attributes params[:suggestion]
      SuggestionsMailer.updated_suggestion(@suggestion).deliver
      redirect_to proposal_path(@proposal), notice: "Suggestion has been updated"
    else
      redirect_to proposal_path(@proposal), alert: "Suggestion could not be updated"
    end
  end

  private

  def fetch_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end
end