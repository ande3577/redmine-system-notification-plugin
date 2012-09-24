class SystemNotificationsHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = { })
    stylesheet_link_tag 'system_notifications.css', :plugin => 'system_notification_plugin', :media => 'screen'
    javascript_include_tag 'system_notifications', :plugin => 'system_notification_plugin' 
  end
end
