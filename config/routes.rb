Nipanipa::Application.routes.draw do

  # first created -> highest priority.

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users,
               skip: :sessions,
               controllers: { registrations: "users" }

    devise_scope :user do
      get    'signin'  => 'devise/sessions#new'    , as: :new_user_session
      post   'signin'  => 'devise/sessions#create' , as: :user_session
      delete 'signout' => 'devise/sessions#destroy', as: :destroy_user_session

      get 'users'     => 'users#index', as: :users
      get 'users/:id' => 'users#show' , as: :user

      get    'users/:user_id/feedbacks/new'      => 'feedbacks#new'   , as: :new_user_feedback
      post   'users/:user_id/feedbacks'          => 'feedbacks#create', as: :user_feedbacks
      get    'users/:user_id/feedbacks/:id/edit' => 'feedbacks#edit'  , as: :edit_user_feedback
      put    'users/:user_id/feedbacks/:id'      => 'feedbacks#update', as: :user_feedback
      delete 'users/:user_id/feedbacks/:id'      => 'feedbacks#destroy'
    end

    resources :donations, only: [:new, :create, :show]

    match 'help'       => 'static_pages#help'
    match 'about'      => 'static_pages#about'
    match 'contact'    => 'static_pages#contact'
    match 'robots.txt' => 'static_pages#robots'

    root :to => 'static_pages#home'

  end


  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
