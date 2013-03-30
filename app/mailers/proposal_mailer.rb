class ProposalMailer < ActionMailer::Base
  default from: "info@euruko2013.org", to: "info@euruko2013.org"
  helper ApplicationHelper

  def new_proposal(proposal)
    @proposal = proposal
    mail subject: 'A new proposal has been posted!'
  end
end
