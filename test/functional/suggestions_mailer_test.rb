require 'test_helper'

class SuggestionsMailerTest < ActionMailer::TestCase
  context "Given a new suggestion" do
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

      should "have default mailer bcc in bcc" do
        assert_includes @mail.bcc, Settings.mailer.bcc
      end

      should "have default mailer from as sender" do
        assert_equal ["info@example.org"], @mail.from
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

      should "have default mailer bcc in bcc" do
        assert_includes @mail.bcc, Settings.mailer.bcc
      end

      should "have info@euruko2013.org as sender" do
        assert_equal ["info@example.org"], @mail.from
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

      should "have default mailer bcc in bcc" do
        assert_includes @mail.bcc, Settings.mailer.bcc
      end

      should "have info@euruko2013.org as sender" do
        assert_equal ["info@example.org"], @mail.from
      end

      should "have body" do
        assert_match @suggestion.body, @mail.body.encoded
      end
    end
  end

  context "Given an updated suggestion" do
    setup do
      @suggestion = FactoryGirl.create(:suggestion)
      @mail = SuggestionsMailer.updated_suggestion @suggestion
    end

    should "have proper subject" do
      assert_equal "Your suggestion on '#{@suggestion.proposal.title}' was moderated!", @mail.subject
    end

    should "have the author as recipient" do
      assert_equal [@suggestion.author.email], @mail.to
    end

    should "have default mailer bcc in bcc" do
      assert_includes @mail.bcc, Settings.mailer.bcc
    end

    should "have default mailer from as sender" do
      assert_equal ["info@example.org"], @mail.from
    end
  end
end
