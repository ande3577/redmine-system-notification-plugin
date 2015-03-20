require 'redmine'
require 'system_notifications_hooks'

Redmine::Plugin.register :system_notification_plugin do
  name 'Redmine System Notification Plugin'
  author 'David S Anderson'
  description 'The System Notification plugin allows Administrators to send system-wide email notifications to specific users.'
  url 'https://github.com/ande3577/redmine-system-notification-plugin'
  author_url 'https://github.com/ande3577'

  version '0.3.0'

  requires_redmine :version_or_higher => '2.0.0'
  
  project_module :system_notification do
    permission :use_system_notification, :system_notification => :index
  end

  
  menu :admin_menu, :system_notification, { :controller => 'system_notification', :action => 'index'},
  { :caption => :system_notification}
  menu :project_menu, :system_notification, { :controller => 'system_notification', :action => 'index'},
   :caption => :system_notification, :if => Proc.new { User.current.allowed_to?({:controller => 'system_notification', :action => 'index'}, @project, :global => true ) }
     
end
