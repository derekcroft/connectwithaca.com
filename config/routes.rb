ActionController::Routing::Routes.draw do |map|
  # RESTful routes
  map.resources :members

  # Named routes for the static site
  map.dealer '/dealer', :controller => "site", :action => "dealer"
  map.recruiting '/recruiting', :controller => "site", :action => "recruiting"
  map.join '/join', :controller => "site", :action => "join"
  
  # Default route
  map.root :controller => "site", :action => "index"
end
