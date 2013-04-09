require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  context 'When moderator' do
    setup do
      @user = FactoryGirl.create(:user, :email => 'someone@euruko2013.org')
      session[:user_id] = @user.id
      get :index
    end

    should assign_to(:proposals_since_selected_time)
    should assign_to(:suggestions_since_selected_time)
    should assign_to(:users_since_selected_time)
    should assign_to(:logins_since_selected_time)
    should assign_to(:time_options)

    context 'and first time in dashboard#index' do
      should assign_to(:selected_time_code) { 'epoch' }
      should respond_with :success
    end

    context "selects a time period of 'Since my last login'" do
      setup do
        @some_time = DateTime.new(2013, 4, 15)
        @user.last_visited_at = @some_time
        get :index, { :dashboard => { :selected_time => 'last_login' } }
      end

      should assign_to(:selected_time) { @some_time }
      should respond_with :success
    end

    context "selects a time period of 'This month'" do
      setup do
        @some_time = DateTime.new(2013, 4, 1)
        @user.last_visited_at = @some_time
        get :index, { :dashboard => { :selected_time => 'this_month' } }
      end

      should assign_to(:selected_time) { @some_time }
      should respond_with :success
    end

    context "selects a time period of 'Everything'" do
      setup do
        @some_time = DateTime.new(1970, 1, 1)
        @user.last_visited_at = @some_time
        get :index, { :dashboard => { :selected_time => 'epoch' } }
      end

      should assign_to(:selected_time) { @some_time }
      should respond_with :success
    end
  end
end