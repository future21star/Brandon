Rails.application.routes.draw do

  get 'dashboard', :to => 'dashboards#dashboard'

  get 'feedback/completed', :to => 'feedbacks#completed'
  resources :feedbacks
  # Order matters
  get 'privacy_policy', :to => 'static_pages#privacy_policy'
  get 'static/map_data/', to: 'static_data#map_data'
  get 'static/captcha_key/', to: 'static_data#captcha_key'
  get 'static/eula/', to: 'static_data#get_eula'

  delete 'measurements/:id', to: 'measurements#destroy', as: 'measurements/destroy'

  post 'measurements/group/', to: 'measurements#create_group', as: 'measurements/group/create'
  put 'measurements/group/:id', to: 'measurements#update_group', as: 'measurements/group/update'
  delete 'measurements/group/:id', to: 'measurements#destroy_group', as: 'measurements/group/destroy'

  post 'terms_and_conditions/accept'
  get 'terms_and_conditions/has_accepted'
  get 'terms_and_conditions/show', :to => 'static_pages#terms_and_conditions'
  get 'terms_and_conditions', to: 'terms_and_conditions#show'

  devise_scope :user do
    get 'registration/completed/:id', to: 'users/registrations#completed', as: 'registration/completed'
    get 'profile', to: 'profiles#show'
    patch 'profile_picture', to: 'profiles#set_profile_picture'
  end

  resources :ratings
  get 'locations/mine', to: 'locations#my_locations'
  resources :locations

  resources :notifications
  resources :notification_templates

  resources :preferences
  patch 'preferences/user', to: 'preferences#update', as: 'user/preferences/update'


  resources :businesses
  post 'business/tag', to: 'businesses#create_tag', as: 'business/tag/create'
  delete 'business/tag', to: 'businesses#destroy_tag', as: 'business/tag/destroy'

  resources :pictures
  get 'landing_page/index', as: 'landing_page'

  resources :addresses
  devise_for :users, :controllers => {
      :confirmations => 'users/confirmations',
      :passwords => 'users/passwords',
      :registrations => 'users/registrations',
      :sessions => 'users/sessions',
      :unlocks => 'users/unlocks',
  }, :format => false
  resources :promo_codes
  resources :tags
  resources :quotes

  get 'purchases/completed', to: 'purchases#completed', :format => false
  get 'purchases/packages', to: 'purchases#list_packages'
  resources :purchases, :format => false, only: [:index, :new, :create, :show]

  get 'projects/mine', to: 'projects#my_projects', as: 'projects_mine'
  resources :projects, :format => false

  get 'estimates/mine', to: 'estimates#my_estimates', as: 'estimates_mine'
  resources :estimates

  resources :landing_page
  resources :quantifiers
  require 'resque-history/server'



  # get 'projects' => 'projects#index'
  # get 'projects/:id' => 'projects#show', :format => false, as: 'projects_show'
  # post 'projects/new' => 'projects#create', :format => false
  # post 'projects/:id' => 'projects#update', :format => false
  post 'projects/:id/spam' => 'projects#report_as_spam', as: 'project_report_as_spam'
  patch 'projects/:id/publish' => 'projects#publish', as: 'publish_project'
  patch 'projects/:id/cancel' => 'projects#cancel', as: 'cancel_project'
  patch 'projects/:id/accept/:estimate_id' => 'projects#accept_quote', as: 'accept_quote'
  get 'projects/search/lat/:lat/lng/:lng', to: 'projects#search', as: 'summaries_search', constraints: {lat: /[-\d.]*/, lng: /[-\d.]*/ }
  post 'projects/:id/tag', to: 'projects#create_tag', as: 'project/tag/create'
  delete 'project/:id/tag', to: 'projects#destroy_tag', as: 'project/tag/destroy'

  get 'tags/find_like_name/:name', to: 'tags#find_like_name', as: 'find_like_name'

  get 'ratings/get_business_ratings/:business_id', to: 'ratings#get_business_ratings'

  patch 'promo_code/:id/cancel' => 'promo_codes#cancel', as: 'cancel_promotion'
  get 'validate_promo_code', to: 'promo_codes#validate_promo_code', :format => false

  get 'user_landing_page', to: 'projects#index'
  get 'business_landing_page', to: 'projects#index'
  get 'admin_landing_page', to: 'tags#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".



  # Business Centre
  get 'account_search', to: 'business_centre#account_search'
  get 'business_search', to: 'business_centre#business_search'


  # You can have the root of your site routed with "root"
  root 'landing_page#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
