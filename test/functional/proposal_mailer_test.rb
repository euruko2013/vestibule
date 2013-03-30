require 'test_helper'

class ProposalMailerTest < ActionMailer::TestCase
  def setup
    @proposal = FactoryGirl.create(:proposal, description: 'Ruby love')
  end

  test "new_proposal" do
    mail = ProposalMailer.new_proposal @proposal
    assert_equal "New proposal guys", mail.subject
    assert_equal ["info@euruko2013.org"], mail.to
    assert_equal ["info@euruko2013.org"], mail.from
    assert_match @proposal.description, mail.body.encoded
  end
end
