class ProposalMailer < ActionMailer::Base
  default from: "info@euruko2013.org", to: "info@euruko2013.org"
  helper ApplicationHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.proposal_mailer.new_proposal.subject
  #
  def new_proposal(proposal)
    @proposal = proposal
    mail subject: 'New proposal guys'
  end
end
