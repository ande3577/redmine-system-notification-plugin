require 'redmine'
require 'system_notifications_hooks'

Redmine::Plugin.register :system_notification_plugin do
  name 'Redmine System Notification plugin'
  author 'David S Anderson'
  description 'The System Notification plugin allows Administrators to send systemwide email notifications to specific users.'
  url 'https://github.com/ande3577/redmine-system-notification-plugin'
  author_url 'https://github.com/ande3577'

  version '0.3.0'

  requires_redmine :version_or_higher => '0.8.0'

  
  menu :admin_menu, :system_notification, { :controller => 'system_notification', :action => 'index'},
  { :caption => :system_notification}
end
