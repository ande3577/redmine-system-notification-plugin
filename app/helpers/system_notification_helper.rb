module SystemNotificationHelper

  def system_notification_project_select
    if @project.nil?
      project_list = Project.find(:all)
    else
      project_list = [@project]
    end
    
    if self.respond_to?(:project_tree_options_for_select)
    
      select_tag('system_notification[projects][]',
                       project_tree_options_for_select(project_list),
                         :multiple => @project.nil?, :size => @project.nil? ? 10 : 1, :id => "system_notification_projects")
    else
      select_tag('system_notification[projects][]',
                      options_from_collection_for_select(project_list, :id, :name),
                         :multiple => @project.nil?, :size => @project.nil? ? 10 : 1, :id => "system_notification_projects")
    end
  end
end
