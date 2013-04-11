require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  context 'When moderator' do
    setup do
      @user = FactoryGirl.create(:user, :email => 'someone@euruko2013.org')
      session[:user_id] = @user.id
      get :index
    end

    should assign_to(:proposals_since_last_visit)
    should assign_to(:proposals)
    should assign_to(:suggestions)
    should assign_to(:upvotes)
    should assign_to(:downvotes)
    should assign_to(:users)

    should respond_with :success
  end
end