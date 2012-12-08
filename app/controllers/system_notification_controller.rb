class SystemNotificationController < ApplicationController
  unloadable
  layout 'base'
  before_filter :check_permissions
  
  def check_permissions
    unless User.current.logged?
      deny_access
      return
    end
    
    if @project.nil?
      projects = params[:id].nil? ? [] : Project.where(:identifier => params[:id])
        
      @project = projects[0] unless projects.empty?
      
      if !params[:projects].nil? 
        if params[:projects].kind_of?(Array)
          params[:projects].each do |p|
            projects << Project.find(p)
          end
        elsif params[:projects] != "null"
          projects << [Project.find(params[:projects])]
        end
      end
      
      if !params[:system_notification].nil? && !params[:system_notification][:projects].nil? && params[:system_notification][:projects].kind_of?(Array)
            params[:system_notification][:projects].each do |p|
              projects << Project.find(p)
            end
      end
        
    else
      projects = [ @project ]
    end
    
    if projects.empty?()
      unless User.current.admin
        deny_access
      end
    else
      projects.each do |project|
        if !User.current.admin? && !User.current.allowed_to?(:use_system_notification, project, :global => false)
          deny_access
        end
      end
    end
  end
  
  def index
    @system_notification = SystemNotification.new
  end
  
  def create
    @system_notification = SystemNotification.new(params[:system_notification])
    if params[:system_notification][:time]
      project_ids = @project.nil? ? params[:system_notification][:projects] : [@project.id]
      
      
      @system_notification.users = SystemNotification.users_since(params[:system_notification][:time],
                                                                  {
                                                                    :projects => project_ids,
                                                                    :roles => params[:system_notification][:roles]
                                                                  })
    end
    if @system_notification.deliver
      flash[:notice] = "System Notification was successfully sent."
      redirect_to_referer_or 
    else
      flash[:error] = "System Notification was not sent."
      redirect_to_referer_or 
    end
  end
  
  def users_since
    if @project.nil?
       project_ids = params[:projects]
    else
       project_ids = [@project.id]
    end
    
    if params[:time] && !params[:time].empty?
      @users = SystemNotification.users_since(params[:time],
                                              {
                                                :projects => project_ids,
                                                :roles => params[:roles]
                                              })
    end
    @users ||= []
      
    logger.info "Found:" + @users.length().to_s + " users."
    
    respond_to do |format|
      format.html { render :partial => 'users', :locals => { :users => @users } }
      format.js { render :partial => 'users', :locals => { :users => @users } }
    end
  end
  
  def preview
    # page is nil when previewing a new page
    if @project.nil? && !User.current.admin?
      return render_403
    elsif !User.current.admin? && !User.current.allowed_to?(:use_system_notification, @project, :global => false)
      return render_403 
    end
    @text = params[:system_notification][:body]
    render :partial => 'common/preview'
  end
end
