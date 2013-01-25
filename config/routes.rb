Nipanipa::Application.routes.draw do

  # This is ugly... I think... better to user AJAX maybe...
  # match 'users/:id' => 'feedbacks#create', via: :post, as: :user_feedbacks
  # This route can be invoked with user_feedbacks_url(:id => user.id)

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    resources :users do
      resources :feedbacks, only: [:new, :create, :index, :destroy]
    end

    resources :sessions,  only: [:new, :create, :destroy]

    match 'signup'  => 'users#new'
    match 'signin'  => 'sessions#new'
    match 'signout' => 'sessions#destroy', via: :delete

    match 'help'    => 'static_pages#help'
    match 'about'   => 'static_pages#about'
    match 'contact' => 'static_pages#contact'

    root :to => 'static_pages#home'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample resource route with options:
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

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
