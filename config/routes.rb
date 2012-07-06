ActionController::Routing::Routes.draw do |map|
  map.connect 'system_notification/:action', :controller => 'SystemNotification'
end