require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  [Phase::ZERO].each do |phase|
    context "During '#{phase.name}'" do
      setup do
        Phase.stubs(:current).returns(phase)
      end

      setup do
        @user = FactoryGirl.create(:user)
        session[:user_id] = @user.id
        get :index
      end

      should respond_with :success

      should assign_to(:your_proposals)
      should_not assign_to(:proposals_you_should_look_at)
      should_not assign_to(:proposals_that_have_changed)
      should_not assign_to(:unvoted_proposals)
      should_not assign_to(:proposals_that_have_been_withdrawn)
    end
  end

  [Phase::ONE].each do |phase|
    context "During '#{phase.name}'" do
      setup do
        Phase.stubs(:current).returns(phase)
      end

      setup do
        @user = FactoryGirl.create(:user)
        session[:user_id] = @user.id
        get :index
      end

      should respond_with :success

      should assign_to(:your_proposals)
      should assign_to(:proposals_you_should_look_at)
      should assign_to(:proposals_that_have_changed)
      should assign_to(:unvoted_proposals)
      should assign_to(:proposals_that_have_been_withdrawn)
    end
  end

  [Phase::INTERLUDE].each do |phase|
    context "During '#{phase.name}'" do
      setup do
        Phase.stubs(:current).returns(phase)
      end

      setup do
        @user = FactoryGirl.create(:user)
        session[:user_id] = @user.id
        get :index
      end

      should respond_with :success

      should assign_to(:your_proposals)
      should_not assign_to(:proposals_you_should_look_at)
      should_not assign_to(:proposals_that_have_changed)
      should assign_to(:unvoted_proposals)
      should assign_to(:proposals_that_have_been_withdrawn)
    end
  end

  [Phase::TWO, Phase::CONFIRMATION].each do |phase|
    context "During '#{phase.name}'" do
      setup do
        Phase.stubs(:current).returns(phase)
      end

      setup do
        @user = FactoryGirl.create(:user)
        session[:user_id] = @user.id
        get :index
      end

      should respond_with :success

      should assign_to(:your_proposals)
      should_not assign_to(:proposals_you_should_look_at)
      should_not assign_to(:proposals_that_have_changed)
      should_not assign_to(:unvoted_proposals)
      should assign_to(:proposals_that_have_been_withdrawn)
    end
  end

  [Phase::LINEUP].each do |phase|
    context "During '#{phase.name}'" do
      setup do
        Phase.stubs(:current).returns(phase)
      end

      setup do
        @user = FactoryGirl.create(:user)
        session[:user_id] = @user.id
        get :index
      end

      should respond_with :success

      should assign_to(:your_proposals)
      should_not assign_to(:proposals_you_should_look_at)
      should_not assign_to(:proposals_that_have_changed)
      should_not assign_to(:unvoted_proposals)
      should_not assign_to(:proposals_that_have_been_withdrawn)
    end
  end
end