class BaseMailer < ActionMailer::Base
  default from: "\"EuRuKo 2013\" <info@euruko2013.org>",
          bcc: ["info@euruko2013.org"]

  helper ApplicationHelper
  layout 'mailer'
end