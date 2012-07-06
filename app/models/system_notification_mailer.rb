class SystemNotificationMailer < Mailer
  def system_notification(system_notification)
    recipients system_notification.users.collect(&:mail)
    subject system_notification.subject
    from Setting['mail_from']
    
    content_type "text/html"
    
    part "text/html" do |p|
      p.body = render_message("system_notification.text.html.erb", :body => system_notification.body)
    end

  end
end
