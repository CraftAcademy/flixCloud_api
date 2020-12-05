Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth', skip: [:omniauth_callbacks]
  namespace :api do
    resources :movies, only: [:index] do
      get 'search', on: :collection
      get 'image/:id', on: :collection, to: 'movies#image'
    end
  end
end
