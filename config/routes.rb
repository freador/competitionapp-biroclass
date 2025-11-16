Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]

  get "/invites/:token", to: "invites#show", as: :invite
  patch "/invites/:token", to: "invites#update"
  get "/competitions/public", to: "competitions#public_index", as: :public_competitions
  get "/competitions/builder", to: "competitions/wizard#show", as: :competition_builder
  patch "/competitions/builder", to: "competitions/wizard#update"

  resources :rankings
  resources :notes
  resources :participants
  resources :competitions do
    member do
      get :public_dashboard
      get :judging
      patch :start
      patch :close
    end

    resources :notes, only: %i[create update], module: :competitions
  end
  resources :users, only: %i[new create]
  resource :profile, only: %i[show edit update]
  resource :brand_guide, only: :show, controller: "brand_guide"

  get "/login", to: "sessions#new"
  get "/signup", to: "users#new"
  delete "/logout", to: "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "competitions#public_index"
end
