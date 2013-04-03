class BaseMailer < ActionMailer::Base
  default from: Settings.mailer.from,
          bcc: [Settings.mailer.bcc]

  helper ApplicationHelper
  layout 'mailer'
end