class ProposalMailer < BaseMailer
  def new_proposal(proposal)
    @proposal = proposal
    mail subject: 'A new proposal has been posted!'
  end
end
