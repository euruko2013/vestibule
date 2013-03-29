require 'test_helper'

class SuggestionsMailerTest < ActionMailer::TestCase
  def setup
    @suggestion = FactoryGirl.create(:suggestion)
  end

  test "new_suggestion" do
    mail = SuggestionsMailer.new_suggestion @suggestion
    assert_equal "Someone just posted a suggestion for your euruko proposal!", mail.subject
    assert_equal [@suggestion.proposal.proposer.email], mail.to
    assert_equal ["info@euruko2013.org"], mail.from
    assert_match @suggestion.body, mail.body.encoded
  end

end
