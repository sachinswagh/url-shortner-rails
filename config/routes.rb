# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :v1 do
    resources :auths do
      collection do
        post 'login', action: 'login'
        post 'logout', action: 'logout'
        post 'sign_up', action: 'sign_up'
      end
    end

    resources :uri do
      collection do
        get :shorten
      end
    end

    resources :auth_details, only: %i[create show]
  end

  get '*path' => 'v1/uri#resolve'
end
