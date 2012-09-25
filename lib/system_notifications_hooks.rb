class SystemNotificationsHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = { })
    o = stylesheet_link_tag('system_notifications', :plugin => 'system_notification_plugin')
    o << javascript_include_tag('system_notifications', :plugin => 'system_notification_plugin')
    return o 
  end
end
