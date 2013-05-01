require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup do
      @user = FactoryGirl.create(:user, :signup_reason => nil)
    end

    should "be valid" do
      assert @user.valid?
    end

    should "respond to last_visited_at" do
      assert @user.respond_to? :last_visited_at
    end

    context "who has made suggestions on a proposal" do
      setup do
        @proposal = FactoryGirl.create(:proposal)
        @old_score = @user.contribution_score
        FactoryGirl.create(:suggestion, :proposal => @proposal, :author => @user)
      end

      should "have that proposal in their proposals of interest" do
        assert_equal [@proposal], @user.reload.proposals_of_interest
      end

      should 'change their contribution_score' do
        assert_equal 0, @old_score
        assert_equal 2, @user.contribution_score
      end

      should 'not change their contribution_score if the suggestion was on their own proposal' do
        @proposal.proposer = @user
        @proposal.save
        @user.update_contribution_score
        assert_equal 0, @user.contribution_score
      end
    end

    context "who makes a proposal" do
      should 'not change their contribution_score (because, anonymous)' do
        assert_equal 0, @user.reload.contribution_score
        FactoryGirl.create(:proposal, :proposer => @user)
        assert_equal 0, @user.reload.contribution_score
      end

      context "that is then suggested upon" do
        setup do
          @proposal = FactoryGirl.create(:proposal, :proposer => @user)
        end
        should 'not change their contribution_score (because, anonymous)' do
          assert_equal 0, @user.reload.contribution_score
          FactoryGirl.create(:suggestion, :proposal => @proposal)
          assert_equal 0, @user.reload.contribution_score
        end
      end
    end

    context 'who provides their motivation' do
      setup do
        @user.signup_reason = nil
        @user.save
      end

      should 'change their contribution_score' do
        assert_equal 0, @user.reload.contribution_score
        @user.signup_reason = 'I want to hear about fun and interesting things that I\'m not exposed to in my day job'
        @user.save
        assert_equal 5, @user.reload.contribution_score
      end
    end

    context 'who wants to signs up' do
      context 'with github' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'github',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the github uid set' do
          assert_equal 'uid', @user.github_uid
        end

        should 'should have the github nickname set' do
          assert_equal 'Nickname', @user.github_nickname
        end
      end

      context 'with facebook' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'facebook',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the facebook uid set' do
          assert_equal 'uid', @user.facebook_uid
        end

        should 'should have the facebook nickname set' do
          assert_equal 'Nickname', @user.facebook_nickname
        end
      end

      context 'with twitter' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'twitter',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the twitter uid set' do
          assert_equal 'uid', @user.twitter_uid
        end

        should 'should have the twitter nickname set' do
          assert_equal 'Nickname', @user.twitter_nickname
        end
      end

      context 'with google' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'google',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the google uid set' do
          assert_equal 'uid', @user.google_uid
        end

        should 'should have the google nickname set' do
          assert_equal 'Nickname', @user.google_nickname
        end
      end
    end

    context 'who has already signed up' do
      context 'with github' do
        setup do
          @existing_user = FactoryGirl.create(:user, :github_uid => 'GITHUB_ID')
        end

        should 'be able to login' do
          logged_in_user = User.find_or_create_with_omniauth(:uid => 'GITHUB_ID', :provider => 'github', :info => {:email => @existing_user.email})
          assert_not_nil logged_in_user
          assert_equal logged_in_user.id, @existing_user.id
        end
      end

      context 'with facebook' do
        setup do
          @existing_user = FactoryGirl.create(:user, :facebook_uid => 'FACEBOOK_ID')
        end

        should 'be able to login' do
          logged_in_user = User.find_or_create_with_omniauth(:uid => 'FACEBOOK_ID', :provider => 'facebook', :info => {:email => @existing_user.email})
          assert_not_nil logged_in_user
          assert_equal logged_in_user.id, @existing_user.id
        end
      end

      context 'with twitter' do
        setup do
          @existing_user = FactoryGirl.create(:user, :twitter_uid => 'TWITTER_ID')
        end

        should 'be able to login' do
          logged_in_user = User.find_or_create_with_omniauth(:uid => 'TWITTER_ID', :provider => 'twitter', :info => {:email => @existing_user.email})
          assert_not_nil logged_in_user
          assert_equal logged_in_user.id, @existing_user.id
        end
      end

      context 'with google' do
        setup do
          @existing_user = FactoryGirl.create(:user, :twitter_uid => 'GOOGLE_ID')
        end

        should 'be able to login' do
          logged_in_user = User.find_or_create_with_omniauth(:uid => 'GOOGLE_ID', :provider => 'google', :info => {:email => @existing_user.email})
          assert_not_nil logged_in_user
          assert_equal logged_in_user.id, @existing_user.id
        end
      end
    end
  end

  context "#add_selections" do
    setup do
      @user = FactoryGirl.create(:user, :signup_reason => nil)
    end

    should "create one selection for every proposal id given with the appropriate position" do
      proposals = FactoryGirl.create_list(:proposal, 3)
      @user.add_selections(proposals.map(&:id))

      assert_equal @user.selections.size, 3

      assert_equal @user.selections.first.position, 1
      assert_equal @user.selections.second.position, 2
      assert_equal @user.selections.third.position, 3

      assert_equal @user.selections.first.proposal, proposals.first
      assert_equal @user.selections.second.proposal, proposals.second
      assert_equal @user.selections.third.proposal, proposals.third
    end

    should "update the positions based on the proposal positions in the list" do
      proposals = FactoryGirl.create_list(:proposal, 3)
      @user.add_selections(proposals.map(&:id))
      @user.add_selections(proposals.map(&:id).reverse)

      assert_equal @user.selections.size, 3

      assert_equal @user.selections.first.position, 1
      assert_equal @user.selections.second.position, 2
      assert_equal @user.selections.third.position, 3

      assert_equal @user.selections.first.proposal, proposals.third
      assert_equal @user.selections.second.proposal, proposals.second
      assert_equal @user.selections.third.proposal, proposals.first
    end

    should "add a new propsoal with the position set correctly" do
      proposals = FactoryGirl.create_list(:proposal, 3)
      @user.add_selections(proposals.map(&:id))
      another_proposal = FactoryGirl.create(:proposal)
      @user.add_selections(proposals.map(&:id).insert(1, another_proposal.id))

      assert_equal @user.selections.size, 4

      assert_equal @user.selections.first.position, 1
      assert_equal @user.selections.second.position, 2
      assert_equal @user.selections.third.position, 3
      assert_equal @user.selections.fourth.position, 4

      assert_equal @user.selections.first.proposal, proposals.first
      assert_equal @user.selections.second.proposal, another_proposal
      assert_equal @user.selections.third.proposal, proposals.second
      assert_equal @user.selections.fourth.proposal, proposals.third
    end

    should "update the list of the selctions with the newly passed array" do
      proposals = FactoryGirl.create_list(:proposal, 3)
      @user.add_selections(proposals.map(&:id))
      other_proposals = FactoryGirl.create_list(:proposal, 4)
      @user.add_selections(other_proposals.map(&:id))

      assert_equal @user.selections.size, 4

      assert_equal @user.selections.first.position, 1
      assert_equal @user.selections.second.position, 2
      assert_equal @user.selections.third.position, 3
      assert_equal @user.selections.fourth.position, 4

      assert_equal @user.selections.first.proposal, other_proposals.first
      assert_equal @user.selections.second.proposal, other_proposals.second
      assert_equal @user.selections.third.proposal, other_proposals.third
      assert_equal @user.selections.fourth.proposal, other_proposals.fourth
    end
  end

  context "#selected_proposals" do
    setup do
      @user = FactoryGirl.create(:user, :signup_reason => nil)
      @proposals = FactoryGirl.create_list(:proposal, 2)
      other_proposals = FactoryGirl.create_list(:proposal, 2)
      @user.add_selections(@proposals.map(&:id))
    end

    should "return the selected proposals" do
      assert_equal @user.selected_proposals, @proposals
    end
  end
end
