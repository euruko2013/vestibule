class SuggestionsMailer < ActionMailer::Base
  default from: "info@euruko2013.org", bcc: "info@euruko2013.org"
  helper ApplicationHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.suggestions_mailer.new_suggestion.subject
  #
  def new_suggestion(suggestion)
    @suggestion = suggestion

    mail to: @suggestion.proposal.proposer.email, subject: "Someone just posted a suggestion on #{@suggestion.proposal.title}!"
  end
end
