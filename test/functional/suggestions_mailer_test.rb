require 'test_helper'

class SuggestionsMailerTest < ActionMailer::TestCase
  def setup
    @suggestion = FactoryGirl.create(:suggestion)
  end

  context "When suggestion author is the proposer" do
    setup do
      @suggestion.proposal.proposer = @suggestion.author
      @mail = SuggestionsMailer.new_suggestion @suggestion
    end

    should "have proper subject" do
      assert_equal "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!", @mail.subject
    end

    should "have no recipient" do
      assert_equal nil, @mail.to
    end

    should "not have proposer in bcc" do
      assert !@suggestion.proposal.proposer.email.in?(@mail.bcc)
    end

    should "have info@euruko2013.org in bcc" do
      assert_includes @mail.bcc, "info@euruko2013.org"
    end

    should "have info@euruko2013.org as sender" do
      assert_equal ["info@euruko2013.org"], @mail.from
    end

    should "have body" do
      assert_match @suggestion.body, @mail.body.encoded
    end
  end

  context "When user wants to receive notifications for suggestions" do
    setup do
      @mail = SuggestionsMailer.new_suggestion @suggestion
    end

    should "have proper subject" do
      assert_equal "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!", @mail.subject
    end

    should "have proposer in bcc" do
      assert_includes @mail.bcc, @suggestion.proposal.proposer.email
    end

    should "have info@euruko2013.org in bcc" do
      assert_includes @mail.bcc, "info@euruko2013.org"
    end

    should "have info@euruko2013.org as sender" do
      assert_equal ["info@euruko2013.org"], @mail.from
    end

    should "have body" do
      assert_match @suggestion.body, @mail.body.encoded
    end
  end

  context "When user doesn't want to receive notifications for suggestions" do
    setup do
      @suggestion.proposal.proposer.subscribe_to_suggestions_notifications = false
      @mail = SuggestionsMailer.new_suggestion @suggestion
    end

    should "have proper subject" do
      assert_equal "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!", @mail.subject
    end

    should "not have proposer in bcc" do
      assert !@suggestion.proposal.proposer.email.in?(@mail.bcc)
    end

    should "have info@euruko2013.org in bcc" do
      assert_includes @mail.bcc, "info@euruko2013.org"
    end

    should "have info@euruko2013.org as sender" do
      assert_equal ["info@euruko2013.org"], @mail.from
    end

    should "have body" do
      assert_match @suggestion.body, @mail.body.encoded
    end
  end
end
