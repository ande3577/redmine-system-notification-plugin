class SystemNotificationController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_optional_project, :check_permissions
  
  def find_optional_project
    @project = Project.where(:identifier => params[:id]).first unless params[:id].nil?
      
    logger.info "@project = #{@project.inspect}"
  
    if @project.nil?
      @project_ids = []
        
      if !params[:projects].nil? and !params[:projects].empty?
        if params[:projects].kind_of?(Array)
          params[:projects].each do |p|
            @project_ids << p
          end
        elsif params[:projects] != "null"
            @project_ids << params[:projects]
        end
      end
      
      if !params[:system_notification].nil? && !params[:system_notification][:projects].nil? && params[:system_notification][:projects].kind_of?(Array)
            params[:system_notification][:projects].each do |p|
              @project_ids << p
            end
      end
      
      @project_ids.each do |project_id|
        return render_404 if Project.where(:id => project_id).empty?
      end
    else
      @project_ids = [ @project.id ]
    end
    
    logger.info "@projects = #{@project_ids.inspect}"
  end
  
  def check_permissions
    unless User.current.logged?
      deny_access
      return
    end
    
    if @project_ids.empty?()
      unless User.current.admin
        deny_access
      end
    else
      @project_ids.each do |project_id|
        if !User.current.admin? && !User.current.allowed_to?(:use_system_notification, Project.find(project_id), :global => false)
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
      @system_notification.users = SystemNotification.users_since(params[:system_notification][:time],
                                                                  {
                                                                    :projects => @project_ids,
                                                                    :roles => params[:system_notification][:roles]
                                                                  })
    end
    
    if params[:system_notification][:cc_self]
      User.current().pref[:no_self_notified] = false
    else
      User.current().pref[:no_self_notified] = true
    end  
    
    if @system_notification.deliver
      flash[:notice] = "System Notification was successfully sent."
      redirect_to  :action => :index, :id => @project.nil? ? nil : @project.identifier
    else
      @system_notification.users = []
      render :action => :index
    end
  end
  
  def users_since
    if params[:time] && !params[:time].empty?
      @users = SystemNotification.users_since(params[:time],
                                              {
                                                :projects => @project_ids,
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
