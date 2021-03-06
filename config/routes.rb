ActionController::Routing::Routes.draw do |map|
  map.resources :expertises
  map.resources :profiles

  # restful_authentication routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.change_password '/change_password', :controller => 'users', :action => 'change_password'

  map.resources :users
  map.resource :session

  # Application resource routes
  map.resources :members do |m|
    m.resource :profile
  end

  # Named routes for the static site
  map.dealer '/dealer', :controller => "site", :action => "dealer"
  map.current_opportunities '/current_opportunities', :controller => "site", :action => "current_opportunities"
  map.recruiting '/recruiting', :controller => "site", :action => "recruiting"
  map.join '/join', :controller => "site", :action => "join"
  map.member_center '/member_center', :controller => "site", :action => "member_center"
  
  # Default route
  map.root :controller => "site", :action => "index"
end
