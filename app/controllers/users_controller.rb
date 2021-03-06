class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def selections
    @selected_proposals = @user.selected_proposals
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
    end

    redirect_to params[:return_to] || user_path(@user)
  end
end
