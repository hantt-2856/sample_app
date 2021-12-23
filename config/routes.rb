Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "static_pages/help"
  get "static_pages/contact"
  get "/signup", to: "users#new"
  root "static_pages#home"
  resources :users, except: %i(new)
  resources :account_activations, only: :edit
end
