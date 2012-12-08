module SystemNotificationHelper

  def system_notification_project_select
    if !@project.nil?
      hidden_field_tag 'system_notification[projects][]', [@project.id], :id => "system_notification_projects"
    else
      project_list = Project.find(:all)
      if self.respond_to?(:project_tree_options_for_select)
      
        select_tag('system_notification[projects][]',
                         project_tree_options_for_select(project_list),
                           :multiple => true, :size => 10, :id => "system_notification_projects")
      else
        select_tag('system_notification[projects][]',
                        options_from_collection_for_select(project_list, :id, :name),
                           :multiple => true, :size => 10, :id => "system_notification_projects")
      end
    end
  end
end
