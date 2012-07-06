ActionController::Routing::Routes.draw do |map|
  map.connect 'admin/system_notification/:action', :controller => 'system_notification'
end