class SuggestionsMailer < ActionMailer::Base
  default from: "info@euruko2013.org", bcc: "info@euruko2013.org"
  helper ApplicationHelper

  def new_suggestion(suggestion)
    @suggestion = suggestion

    mail to: @suggestion.proposal.proposer.email, subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end
