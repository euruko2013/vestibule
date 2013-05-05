require "test_helper"

class ProposalTest < ActiveSupport::TestCase
  context "A proposal" do
    setup do
      @proposal = FactoryGirl.create(:proposal)
    end

    should "be valid" do
      assert @proposal.valid?
    end

    context "last modified" do

      should "be last modified when updated after last suggestion was added" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 4 2011")) do
          @proposal.description = "Now change something"
          @proposal.save!
        end

        assert_equal Time.parse("Sep 4 2011"), @proposal.last_modified
      end

      should "be last modified when last suggestion was added" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }

        assert_equal Time.parse("Sep 3 2011"), @proposal.last_modified
      end

      should "be last modified when last suggestion was added by proposer" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 5 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal, :author => @proposal.proposer) }

        assert_equal Time.parse("Sep 5 2011"), @proposal.last_modified
      end

      should "be last modified when it was last updated" do
        assert_equal @proposal.updated_at, @proposal.last_modified
      end
    end

    context "update_phase_one_stats!" do
      setup do
        # Two positive votes from users with more than one votes
        proposal2 = FactoryGirl.create(:proposal)
        proposal3 = FactoryGirl.create(:proposal)
        proposal4 = FactoryGirl.create(:proposal)

        user1 = FactoryGirl.create(:user)
        user1.vote_for(@proposal)
        user1.vote_for(proposal2)

        user2 = FactoryGirl.create(:user)
        user2.vote_for(@proposal)
        user2.vote_for(proposal2)

        # One positive vote from user with only one vote
        user3 = FactoryGirl.create(:user)
        user3.vote_for(@proposal)

        # One negative vote from user with more than one vote
        user4 = FactoryGirl.create(:user)
        user4.vote_for(proposal2)
        user4.vote_against(@proposal)

        # Ten public impressions
        10.times { |_| Impression.create!(:impressionable_id => @proposal.id, :impressionable_type => 'Proposal') }

        # Two users have view it multiple times
        10.times { |_| Impression.create!(:impressionable_id => @proposal.id, :impressionable_type => 'Proposal', :user_id => user1.id) }
        20.times { |_| Impression.create!(:impressionable_id => @proposal.id, :impressionable_type => 'Proposal', :user_id => user2.id) }

        # Ten users have viewed 3 unique proposals
        10.times {
          user = FactoryGirl.create(:user)
          Impression.create!(:impressionable_id => proposal2.id, :impressionable_type => 'Proposal', :user_id => user.id)
          Impression.create!(:impressionable_id => proposal3.id, :impressionable_type => 'Proposal', :user_id => user.id)
          Impression.create!(:impressionable_id => proposal4.id, :impressionable_type => 'Proposal', :user_id => user.id)
        }

        @proposal.update_phase_one_stats!
        @proposal.reload
      end

      should "set counted_votes_for" do
        assert_equal 2, @proposal.counted_votes_for
      end

      should "set counted_votes_against" do
        assert_equal 1, @proposal.counted_votes_against
      end

      should "set votes_wilson_score" do
        assert_equal 0.207659602473242, @proposal.votes_wilson_score
      end

      should "set counted_impressions" do
        assert_equal 2, @proposal.counted_impressions
      end

      should "set views_wilson_score" do
        assert_equal 0.0469651425416312, @proposal.views_wilson_score
      end

      should "set total_wilson_score" do
        assert_equal 0.17552071048692, @proposal.total_wilson_score
      end
    end

    context "rank_phase_one!" do
      setup do
        @proposal.destroy

        @proposal1 = FactoryGirl.create(:proposal, :total_wilson_score => 0.1)
        @proposal2 = FactoryGirl.create(:proposal, :total_wilson_score => 0.2)
        @proposal3 = FactoryGirl.create(:proposal, :total_wilson_score => 0.3)
        @proposal4 = FactoryGirl.create(:proposal, :total_wilson_score => 0.4)

        Proposal.rank_phase_one!
      end

      should "set phase_one_ranking" do
        assert_equal [@proposal4.id, @proposal3.id, @proposal2.id, @proposal1.id],
                     Proposal.order(:phase_one_ranking).map { |p| p.id }
      end
    end

    context "nominate!" do
      setup do
        @proposal.destroy

        # Set 1 and 2 from the same author and rank 1 and 2
        @user1 = FactoryGirl.create(:user)
        @proposal1 = FactoryGirl.create(:proposal, :proposer => @user1, :phase_one_ranking => 1)
        @proposal2 = FactoryGirl.create(:proposal, :proposer => @user1, :phase_one_ranking => 2)

        # Set 3..40 from different authors with proper ranking
        (3..40).to_a.each do |i|
          user = FactoryGirl.create(:user)
          instance_variable_set("@user#{i-1}".to_sym, user)
          instance_variable_set("@proposal#{i}".to_sym, FactoryGirl.create(:proposal, :proposer => user, :phase_one_ranking => i))
        end

        # Set 41 as nominated and rank 41
        @user40 = FactoryGirl.create(:user)
        @proposal41 = FactoryGirl.create(:proposal, :proposer => @user40, :nominated => true)

        # Run nominate!
        Proposal.nominate!
        @nominated = Proposal.where(:nominated => true)
      end

      should "have 30 nominations" do
        assert_equal 30, @nominated.size
      end

      should "exclude multiple submissions from same author" do
        refute @proposal2.in?(@nominated)
      end

      should "reset old nominations" do
        refute @proposal41.in?(@nominated)
      end
    end
  end
end
