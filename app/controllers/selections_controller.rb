class SelectionsController < ApplicationController
  skip_authorization_check
  respond_to :json

	def create
		current_user.add_selections(params[:proposal_ids])
    render nothing: true, status: :created
	end
end
