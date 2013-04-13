require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    session[:user_id] = @user.id
    get :index
  end

  should respond_with :success

  should assign_to(:your_proposals)
  should assign_to(:proposals_you_should_look_at)
  should assign_to(:proposals_that_have_changed)
  should assign_to(:proposals_that_have_been_withdrawn)
end