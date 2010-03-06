ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session

  # RESTful routes
  map.resources :members

  # Named routes for the static site
  map.dealer '/dealer', :controller => "site", :action => "dealer"
  map.recruiting '/recruiting', :controller => "site", :action => "recruiting"
  map.join '/join', :controller => "site", :action => "join"
  
  # Default route
  map.root :controller => "site", :action => "index"
end
