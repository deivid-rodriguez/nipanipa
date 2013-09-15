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
    end

    resources :conversations, except: [:edit, :update] do
      put 'reply', on: :member
    end

    get 'help'       => 'static_pages#help'
    get 'about'      => 'static_pages#about'
    get 'contact'    => 'static_pages#contact'
    get 'terms'      => 'static_pages#terms'
    get 'robots.txt' => 'static_pages#robots'

    root 'static_pages#home'
  end

end
