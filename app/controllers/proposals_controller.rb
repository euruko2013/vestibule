class ProposalsController < ApplicationController
  impressionist :actions=> [:show]

  respond_to :html
  respond_to :rss, :only => [:index, :show]

  def index
    authorize! :read, Proposal

    @proposals = Proposal.active.order('created_at desc').includes(:suggestions)
    @withdrawn_proposals = Proposal.withdrawn.includes(:suggestions)
    @suggested_proposal = current_user.proposals_without_own_votes.active.sample || Proposal.active.sample if current_user
    @selected_proposals = current_user.selections.includes(:proposal).map(&:proposal) if current_user

    if can? :see_nominations, Proposal
      @nominated_proposals = Proposal.active.where(:nominated => true).order(:phase_one_ranking)
      @leftout_proposals = Proposal.active.where(:nominated => false).order(:phase_one_ranking)
    end

    respond_with @proposals
  end

  def show
    @proposal = Proposal.find(params[:id])
    authorize! :read, @proposal

    @previous_proposal = Proposal.active.where("id < ?", @proposal).order("id DESC").first
    @next_proposal = Proposal.active.where("id > ?", @proposal).order("id ASC").first

    @suggestion = Suggestion.new if can?(:create, Suggestion)

    respond_with @proposal
  end

  def new
    @proposal = Proposal.new({:proposer => current_user}.merge(params[:proposal] || {}))
    authorize! :new, @proposal
  end

  def create
    @proposal = Proposal.new({:proposer => current_user}.merge(params[:proposal] || {}))
    authorize! :create, @proposal

    if @proposal.save
      ProposalMailer.new_proposal(@proposal).deliver
      redirect_to proposals_path
    else
      render :new
    end
  end

  def edit
    @proposal = Proposal.find(params[:id])
    authorize! :edit, @proposal
  end

  def update
    @proposal = Proposal.find(params[:id])
    authorize! :update, @proposal

    if @proposal.update_attributes(params[:proposal])
      redirect_to proposal_path(@proposal)
    else
      render :edit
    end
  end

  def withdraw
    @proposal = Proposal.find(params[:id])
    authorize! :withdraw, @proposal

    @proposal.withdraw!
    redirect_to proposal_path(@proposal), alert: "Your proposal has been withdrawn"
  end

  def republish
    @proposal = Proposal.find(params[:id])
    authorize! :republish, @proposal

    @proposal.republish!
    redirect_to proposal_path(@proposal), notice: "Your proposal has been republished"
  end

  def vote
    @proposal = Proposal.find(params[:id])
    authorize! :vote, @proposal

    if params[:vote] == 'clear'
      current_user.unvote_for(@proposal)
      flash[:notice] = 'Your vote has been cleared. Remember to come back to vote again once you are sure!'
    else
      current_user.vote(@proposal, :direction => params[:vote], :exclusive => true )
      flash[:notice] = 'Thank you for casting your vote. Your vote has been captured!'
    end

    redirect_to proposal_path(@proposal)
  end
end
