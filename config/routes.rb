if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
     # match requires request method specification in Rails 4
     match 'admin/system_notification/:action', :to => 'system_notification', via: :get
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.connect 'admin/system_notification/:action', :controller => 'system_notification'
  end
end