Nipanipa::Application.routes.draw do

  # first created -> highest priority.

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users,
               skip: :sessions,
               controllers: { registrations: "users", passwords: "passwords" }

    devise_scope :user do
      get    'signin'  => 'devise/sessions#new'    , as: :new_user_session
      post   'signin'  => 'devise/sessions#create' , as: :user_session
      delete 'signout' => 'devise/sessions#destroy', as: :destroy_user_session

      get 'users/:id'  => 'users#show', as: :user
      get 'users'      => 'users#index', as: :users
    end

    resources :donations, only: [:new, :create, :show]

    resources :users do
      resources :pictures
      resources :feedbacks
      resources :conversations, except: [:edit, :update] do
        put 'reply', on: :member
      end
    end

    match 'help'       => 'static_pages#help'
    match 'about'      => 'static_pages#about'
    match 'contact'    => 'static_pages#contact'
    match 'robots.txt' => 'static_pages#robots'

    root :to => 'static_pages#home'

  end

  # Sample resource route with options:
  #   resources :products do
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
