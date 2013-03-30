class SuggestionsMailer < ActionMailer::Base
  default from: "info@euruko2013.org",
          bcc: "info@euruko2013.org"
  helper ApplicationHelper

  def new_suggestion(suggestion)
    @suggestion = suggestion

    recipient =
        @suggestion.proposal.proposer != @suggestion.author &&
        @suggestion.proposal.proposer.subscribe_to_suggestions_notifications? ?
            @suggestion.proposal.proposer.email : nil

    mail to: recipient,
         subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end
