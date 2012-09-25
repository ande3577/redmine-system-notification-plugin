class SystemNotificationMailer < Mailer
  def system_notification(system_notification)
    @author = User.current()
    @system_notification = system_notification
    mail(:to => system_notification.users.collect(&:mail), :subject => system_notification.subject)
  end
end
