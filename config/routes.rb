Rails.application.routes.draw do
  devise_for :clients, skip: :registrations
  devise_for :staffs, skip: :registrations

  root to: 'application#index'

  namespace :clients do
    root to: 'home#index'
    get '/profile', to: 'home#profile'
    resources :organizations, only: :index
  end

  namespace :staffs do
    root to: 'home#index'
    get '/profile', to: 'home#profile'
    post '/validate_client', to: 'clients#validate_uniqueness'
    post '/validate_organization', to: 'organizations#validate_uniqueness'
    resources :clients, only: [:index, :create, :update, :destroy]
    resources :organizations, only: [:index, :create, :update, :destroy]
  end

  namespace :api do
    namespace :v1 do
      post 'auth', to: 'api_token#create'
      namespace :clients do
        resources :home, only: :show
      end
      namespace :staffs do
        resources :home, only: :show
      end
    end
  end

  get 'staffs/*slug', to: 'staffs/home#index'
  get 'clients/*slug', to: 'clients/home#index'
end
