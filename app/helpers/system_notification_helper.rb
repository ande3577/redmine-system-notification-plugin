module SystemNotificationHelper

  def system_notification_project_select
    html = ""
    if !@project.nil?
      html << hidden_field_tag('id', @project.identifier)
      html << hidden_field_tag('system_notification[projects][]', [@project.id], :id => "system_notification_projects")
    else
      # replaced deprecated find(:all)
      project_list = Project.all()
      if self.respond_to?(:project_tree_options_for_select)
      
        html << select_tag('system_notification[projects][]',
                         project_tree_options_for_select(project_list),
                           :multiple => true, :size => 10, :id => "system_notification_projects")
      else
        html << select_tag('system_notification[projects][]',
                        options_from_collection_for_select(project_list, :id, :name),
                           :multiple => true, :size => 10, :id => "system_notification_projects")
      end
    end
    html.html_safe
  end
end
