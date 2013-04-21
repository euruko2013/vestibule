require "test_helper"

class PhaseTest < ActiveSupport::TestCase
  context "Phase selection" do
    should "select zero before 28th of March" do
      Timecop.freeze(DateTime.parse('2013-03-27T00:00:00+2')) do
        assert_equal Phase::ZERO, Phase.current
      end
    end

    should "select one on 28th of March" do
      Timecop.freeze(DateTime.parse('2013-03-28T00:00:00+2')) do
        assert_equal Phase::ONE, Phase.current
      end
    end

    should "select interlude on 24th of April" do
      Timecop.freeze(DateTime.parse('2013-04-24T00:00:00+3')) do
        assert_equal Phase::INTERLUDE, Phase.current
      end
    end

    should "select two on 29th of April" do
      Timecop.freeze(DateTime.parse('2013-04-29T00:00:00+3')) do
        assert_equal Phase::TWO, Phase.current
      end
    end

    should "select confirmation on 6th of May" do
      Timecop.freeze(DateTime.parse('2013-05-06T00:00:00+3')) do
        assert_equal Phase::CONFIRMATION, Phase.current
      end
    end

    should "select lineup on 9th of May" do
      Timecop.freeze(DateTime.parse('2013-05-09T00:00:00+3')) do
        assert_equal Phase::LINEUP, Phase.current
      end
    end
  end

  context "Phase zero" do
    setup do
      @phase = Phase::ZERO
    end

    should "not allow new submissions" do
      assert !@phase.new_submissions_allowed?
    end

    should "not allow submission editing" do
      assert !@phase.submission_editing_allowed?
    end

    should "not allow new suggestions" do
      assert !@phase.new_suggestions_allowed?
    end

    should "not allow voting" do
      assert !@phase.voting_allowed?
    end

    should "not allow submission withdrawal" do
      assert !@phase.submission_withdrawal_allowed?
    end
  end

  context "Phase one" do
    setup do
      @phase = Phase::ONE
    end

    should "allow new submissions" do
      assert @phase.new_submissions_allowed?
    end

    should "allow submission editing" do
      assert @phase.submission_editing_allowed?
    end

    should "allow new suggestions" do
      assert @phase.new_suggestions_allowed?
    end

    should "allow voting" do
      assert @phase.voting_allowed?
    end

    should "allow submission withdrawal" do
      assert @phase.submission_withdrawal_allowed?
    end
  end

  context "Interlude" do
    setup do
      @phase = Phase::INTERLUDE
    end

    should "not allow new submissions" do
      assert !@phase.new_submissions_allowed?
    end

    should "not allow submission editing" do
      assert !@phase.submission_editing_allowed?
    end

    should "not allow new suggestions" do
      assert !@phase.new_suggestions_allowed?
    end

    should "allow voting" do
      assert @phase.voting_allowed?
    end

    should "allow submission withdrawal" do
      assert @phase.submission_withdrawal_allowed?
    end
  end

  context "Phase two" do
    setup do
      @phase = Phase::TWO
    end

    should "not allow new submissions" do
      assert !@phase.new_submissions_allowed?
    end

    should "not allow submission editing" do
      assert !@phase.submission_editing_allowed?
    end

    should "not allow new suggestions" do
      assert !@phase.new_suggestions_allowed?
    end

    should "not allow voting" do
      assert !@phase.voting_allowed?
    end

    should "allow submission withdrawal" do
      assert @phase.submission_withdrawal_allowed?
    end
  end

  context "Confirmation" do
    setup do
      @phase = Phase::CONFIRMATION
    end

    should "not allow new submissions" do
      assert !@phase.new_submissions_allowed?
    end

    should "not allow submission editing" do
      assert !@phase.submission_editing_allowed?
    end

    should "not allow new suggestions" do
      assert !@phase.new_suggestions_allowed?
    end

    should "not allow voting" do
      assert !@phase.voting_allowed?
    end

    should "allow submission withdrawal" do
      assert @phase.submission_withdrawal_allowed?
    end
  end

  context "Lineup" do
    setup do
      @phase = Phase::LINEUP
    end

    should "not allow new submissions" do
      assert !@phase.new_submissions_allowed?
    end

    should "not allow submission editing" do
      assert !@phase.submission_editing_allowed?
    end

    should "not allow new suggestions" do
      assert !@phase.new_suggestions_allowed?
    end

    should "not allow voting" do
      assert !@phase.voting_allowed?
    end

    should "not allow submission withdrawal" do
      assert !@phase.submission_withdrawal_allowed?
    end
  end
end
