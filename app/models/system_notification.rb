class SystemNotification
  attr_accessor :time
  attr_accessor :subject
  attr_accessor :body
  attr_accessor :users
  attr_accessor :errors
  attr_accessor :roles

  if Redmine.const_defined?(:I18n)
    include Redmine::I18n
  else
    include GLoc
  end

  def initialize(options = { })
    self.errors = { }
    self.users = options[:users] || []
    self.subject = options[:subject]
    self.body = options[:body]
  end
  
  def valid?
    self.errors = { }
    if self.subject.blank?
      self.errors['subject'] = 'activerecord_error_blank'
    end
    
    if self.body.blank?
      self.errors['body'] = 'activerecord_error_blank'
    end
    
    if self.users.empty?
      self.errors['users'] = 'activerecord_error_empty'
    end
    
    return self.errors.empty?
  end
  
  def deliver
    if self.valid?
      SystemNotificationMailer.system_notification(self).deliver
      return true
    else
      return false
    end
  end
  
  def self.times
    {
      :day => ll(current_language, :text_24_hours),
      :week => ll(current_language, :text_1_week),
      :month => ll(current_language, :text_1_month),
      :this_year => ll(current_language, :text_this_year),
      :all => ll(current_language, :text_all_time)
    } 
  end

  def self.users_since(time, filters = { })
    Rails.logger.debug ":roles = #{filters[:roles]}"
    
    if SystemNotification.times.include?(time.to_sym)
      users = User.where(:status => User::STATUS_ACTIVE)
      users = users.where("`last_login_on` > (?)", time_frame(time))  unless time.to_sym == :all
      if filters[:projects] != "null" and !filters[:projects].nil?
        members = Member.having("user_id IN (?)", users.pluck(:id))
        members = members.where("project_id IN (?)", filters[:projects])

        if filters[:roles] != "null" and !filters[:roles].nil?
          member_roles = MemberRole.having("member_id IN (?)", members.map(&:id))
          member_roles = member_roles.where("role_id IN (?)", filters[:roles])
          members = Member.where("id IN (?)", member_roles.pluck(:member_id)) 
        end
        
        return members.collect(&:user).uniq 
      else
        if filters[:roles] != "null" and !filters[:roles].nil?
          users_with_role = []
          
          users.each do |u|
            projects_by_role = u.projects_by_role 
              
            filters[:roles].each do |r|
              role = Role.find(r)
              users_with_role << u unless projects_by_role.values_at(role).flatten.empty?
            end
          end
          
          return users_with_role.uniq
        else
          return users
        end
      end
    else
      return []
    end
  end
  
  private
  
  def self.time_frame(time)
    case time.to_sym
    when :day
      1.day.ago
    when :week
      7.days.ago
    when :month
      1.month.ago
    when :this_year
      Time.parse('Jan 1 ' + Time.now.year.to_s)
    else
      nil
    end
  end

  def self.conditions(time, filters = { })
    c = [];
    c.insert ["#{User.table_name}.status = ?", User::STATUS_ACTIVE]
    c.insert ["#{User.table_name}.last_login_on > (?)", time_frame(time)] unless time.to_sym == :all
    c.insert ["project_id IN (?)", filters[:projects]] if filters[:projects]
    return c
  end

end
