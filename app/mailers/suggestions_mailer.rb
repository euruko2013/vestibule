class SuggestionsMailer < BaseMailer
  def new_suggestion(suggestion)
    @suggestion = suggestion

    proposer =
        @suggestion.proposal.proposer != @suggestion.author &&
        @suggestion.proposal.proposer.subscribe_to_suggestions_notifications? ?
            @suggestion.proposal.proposer.email : nil

    mail subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!",
         bcc: [self.class.default[:bcc], proposer].flatten.compact
  end
end
