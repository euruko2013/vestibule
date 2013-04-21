require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase
  def setup
    @viewer = FactoryGirl.create(:user)
    @proposer = FactoryGirl.create(:user)
    @proposal = FactoryGirl.create(:proposal, :proposer => @proposer)
  end

  context 'During phase one' do
    setup do
      Phase.stubs(:current).returns(Phase::ONE)
    end

    context 'When visitor' do
      context 'on #POST to create' do
        setup do
          post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
        end

        should assign_to(:proposal) { @proposal }
        should assign_to(:suggestion)
        should respond_with(:redirect)
        should set_the_flash.to(/You need to sign in or sign up before continuing/)

        should "save suggestion" do
          assert !assigns(:suggestion).persisted?
        end
      end

      context 'on #POST to update' do
        setup do
          @suggestion = FactoryGirl.create(:suggestion)
          put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
        end

        should assign_to(:proposal) { @proposal }
        should assign_to(:suggestion)
        should respond_with(:redirect)
        should set_the_flash.to(/You need to sign in or sign up before continuing/)

        should "not update suggestion" do
          assert_equal 1, @suggestion.versions.size
        end
      end
    end

    context 'When viewer' do
      setup do
        session[:user_id] = @viewer.id
      end

      context 'on #POST to create' do
        setup do
          post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
        end

        should assign_to(:proposal) { @proposal }
        should assign_to(:suggestion)
        should respond_with(:redirect)
        should set_the_flash.to(/Your suggestion has been published/)

        should "save suggestion" do
          assert assigns(:suggestion).persisted?
        end

        should "send email" do
          assert !ActionMailer::Base.deliveries.empty?
        end
      end

      context 'on #POST to update' do
        setup do
          @suggestion = FactoryGirl.create(:suggestion, :author => @viewer)
          put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
        end

        should assign_to(:proposal) { @proposal }
        should assign_to(:suggestion)
        should respond_with(:redirect)
        should set_the_flash.to(/You are not authorized to access this page/)

        should "not update suggestion" do
          assert_equal 1, @suggestion.versions.size
        end
      end
    end

    context 'When proposer' do
      setup do
        session[:user_id] = @proposer.id
      end

      context 'on #POST to create' do
        setup do
          post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
        end

        should assign_to(:proposal) { @proposal }
        should assign_to(:suggestion)
        should respond_with(:redirect)
        should set_the_flash.to(/Your suggestion has been published/)

        should "save suggestion" do
          assert assigns(:suggestion).persisted?
        end

        should "send email" do
          assert !ActionMailer::Base.deliveries.empty?
        end
      end

      context 'on #POST to update' do
        context 'own suggestion' do
          setup do
            @suggestion = FactoryGirl.create(:suggestion, :author => @proposer)
            put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/You are not authorized to access this page/)

          should "not update suggestion" do
            assert_equal 1, @suggestion.versions.size
          end
        end

        context 'someone else suggestion' do
          setup do
            @suggestion = FactoryGirl.create(:suggestion)
            put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/You are not authorized to access this page/)

          should "not update suggestion" do
            assert_equal 1, @suggestion.versions.size
          end
        end
      end
    end

    context 'When moderator' do
      setup do
        @moderator = FactoryGirl.create(:user, :email => 'moderator@euruko2013.org')
        session[:user_id] = @moderator
      end

      context 'on #POST to update' do
        context 'own suggestion' do
          setup do
            @suggestion = FactoryGirl.create(:suggestion, :author => @moderator)
            put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/Suggestion has been updated/)

          should "update suggestion" do
            assert_equal 2, @suggestion.versions.size
          end

          should "send email" do
            assert !ActionMailer::Base.deliveries.empty?
          end
        end

        context 'someone else suggestion' do
          setup do
            @suggestion = FactoryGirl.create(:suggestion)
            put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/Suggestion has been updated/)

          should "update suggestion" do
            assert_equal 2, @suggestion.versions.size
          end

          should "send email" do
            assert !ActionMailer::Base.deliveries.empty?
          end
        end
      end

    end
  end

  [Phase.all - [Phase::ONE]].flatten.each do |phase|
    context "During '#{phase.name}'" do
      setup do
        Phase.stubs(:current).returns(phase)
      end

      context 'When visitor' do
        context 'on #POST to create' do
          setup do
            post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/You need to sign in or sign up before continuing/)

          should "save suggestion" do
            assert !assigns(:suggestion).persisted?
          end
        end

        context 'on #POST to update' do
          setup do
            @suggestion = FactoryGirl.create(:suggestion)
            put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/You need to sign in or sign up before continuing/)

          should "not update suggestion" do
            assert_equal 1, @suggestion.versions.size
          end
        end
      end

      context 'When viewer' do
        setup do
          session[:user_id] = @viewer.id
        end

        context 'on #POST to create' do
          setup do
            post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)

          should "not save suggestion" do
            assert !assigns(:suggestion).persisted?
          end
        end

        context 'on #POST to update' do
          setup do
            @suggestion = FactoryGirl.create(:suggestion, :author => @viewer)
            put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)
          should set_the_flash.to(/You are not authorized to access this page/)

          should "not update suggestion" do
            assert_equal 1, @suggestion.versions.size
          end
        end
      end

      context 'When proposer' do
        setup do
          session[:user_id] = @proposer.id
        end

        context 'on #POST to create' do
          setup do
            post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
          end

          should assign_to(:proposal) { @proposal }
          should assign_to(:suggestion)
          should respond_with(:redirect)

          should "not save suggestion" do
            assert !assigns(:suggestion).persisted?
          end
        end

        context 'on #POST to update' do
          context 'own suggestion' do
            setup do
              @suggestion = FactoryGirl.create(:suggestion, :author => @proposer)
              put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
            end

            should assign_to(:proposal) { @proposal }
            should assign_to(:suggestion)
            should respond_with(:redirect)
            should set_the_flash.to(/You are not authorized to access this page/)

            should "not update suggestion" do
              assert_equal 1, @suggestion.versions.size
            end
          end

          context 'someone else suggestion' do
            setup do
              @suggestion = FactoryGirl.create(:suggestion)
              put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
            end

            should assign_to(:proposal) { @proposal }
            should assign_to(:suggestion)
            should respond_with(:redirect)
            should set_the_flash.to(/You are not authorized to access this page/)

            should "not update suggestion" do
              assert_equal 1, @suggestion.versions.size
            end
          end
        end
      end

      context 'When moderator' do
        setup do
          @moderator = FactoryGirl.create(:user, :email => 'moderator@euruko2013.org')
          session[:user_id] = @moderator
        end

        context 'on #POST to update' do
          context 'own suggestion' do
            setup do
              @suggestion = FactoryGirl.create(:suggestion, :author => @moderator)
              put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
            end

            should assign_to(:proposal) { @proposal }
            should assign_to(:suggestion)
            should respond_with(:redirect)
            should set_the_flash.to(/Suggestion has been updated/)

            should "update suggestion" do
              assert_equal 2, @suggestion.versions.size
            end

            should "send email" do
              assert !ActionMailer::Base.deliveries.empty?
            end
          end

          context 'someone else suggestion' do
            setup do
              @suggestion = FactoryGirl.create(:suggestion)
              put :update, :proposal_id => @proposal.to_param, :id => @suggestion.id, :suggestion => FactoryGirl.attributes_for(:suggestion)
            end

            should assign_to(:proposal) { @proposal }
            should assign_to(:suggestion)
            should respond_with(:redirect)
            should set_the_flash.to(/Suggestion has been updated/)

            should "update suggestion" do
              assert_equal 2, @suggestion.versions.size
            end

            should "send email" do
              assert !ActionMailer::Base.deliveries.empty?
            end
          end
        end
      end
    end
  end
end