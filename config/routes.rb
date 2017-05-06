# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, skip: :registrations,
                       path_names: { sign_in: "signin", sign_out: "signout" }

    devise_scope :user do
      scope :join do
        get :host, to: "users#new",
                   as: :host_registration,
                   defaults: { type: "host" }

        get :volunteer, to: "users#new",
                        as: :volunteer_registration,
                        defaults: { type: "volunteer" }

        post "" => "users#create", as: :user_registration
      end

      scope :account do
        get :cancel, to: "users#cancel", as: :cancel_user_registration

        get :edit, to: "users#edit", as: :edit_user_registration
        patch :update, to: "users#update", as: :update_user_registration

        get :delete, to: "users#delete", as: :confirm_delete_account
        delete :destroy, to: "users#destroy", as: :delete_account
      end
    end

    resources :countries, only: [] do
      resources :regions, only: :index
    end

    resources :donations, only: %i[new create show]

    resources :users, only: %i[index show], constraints: { id: /\d+/ } do
      resources :pictures
      resources :feedbacks, except: :show
    end

    resources :conversations, except: %i[new create]

    get "help" => "static_pages#help"
    get "about" => "static_pages#about"
    get "contact" => "static_pages#contact"
    get "terms" => "static_pages#terms"
    get "robots.txt" => "static_pages#robots"

    root "static_pages#home"
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
