class SelectionsController < ApplicationController
  respond_to :json

  def create
    authorize! :create, Selection
    current_user.add_selections(params[:proposal_ids])
    render nothing: true, status: :created
  end
end
