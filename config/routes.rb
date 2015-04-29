Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, controllers: { registrations: 'users' },
                       path_names: { sign_in: 'signin', sign_out: 'signout' }

    resources :countries, only: [] do
      resources :regions, only: :index
    end

    resources :donations, only: [:new, :create, :show]

    resources :users, except: [:new, :create, :edit, :update, :destroy],
                      constraints: { id: /\d+/ } do
      resources :pictures
      resources :feedbacks
    end

    resources :conversations, except: %i(new create)

    get 'help' => 'static_pages#help'
    get 'about' => 'static_pages#about'
    get 'contact' => 'static_pages#contact'
    get 'terms' => 'static_pages#terms'
    get 'robots.txt' => 'static_pages#robots'

    root 'static_pages#home'
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
