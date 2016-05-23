class NotificationMailer < ApplicationMailer

  default :from => "noreply@thinksoftware.com"

  def new_message(message)
    @message = message
    mail(:subject => "[Thinks] #{message.subject}")
  end
end
