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

    should "not have author as recipient" do
      assert_equal [], @mail.to
    end

    should "have info@euruko2013.org in bcc" do
      assert_equal ["info@euruko2013.org"], @mail.bcc
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

    should "have author as recipient" do
      assert_equal [@suggestion.proposal.proposer.email], @mail.to
    end

    should "have info@euruko2013.org in bcc" do
      assert_equal ["info@euruko2013.org"], @mail.bcc
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

    should "not have author as recipient" do
      assert_equal [], @mail.to
    end

    should "have info@euruko2013.org in bcc" do
      assert_equal ["info@euruko2013.org"], @mail.bcc
    end

    should "have info@euruko2013.org as sender" do
      assert_equal ["info@euruko2013.org"], @mail.from
    end

    should "have body" do
      assert_match @suggestion.body, @mail.body.encoded
    end
  end
end
