require 'test_helper'

class ProposalMailerTest < ActionMailer::TestCase
  def setup
    @proposal = FactoryGirl.create(:proposal, description: 'Ruby love')
  end

  test "new_proposal" do
    mail = ProposalMailer.new_proposal @proposal
    assert_equal "A new proposal has been posted!", mail.subject
    assert_equal nil, mail.to
    assert_equal ["info@example.org"], mail.bcc
    assert_equal ["info@example.org"], mail.from
    assert_match @proposal.description, mail.body.encoded
  end
end
