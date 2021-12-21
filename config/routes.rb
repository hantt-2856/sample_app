Rails.application.routes.draw do
  get "static_pages/help"
  get "static_pages/contact"
  get "/signup", to: "users#new"
  resources :users, only: %i(create show)
  root "static_pages#home"
end
