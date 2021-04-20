Rails.application.routes.draw do
  root "homes#top"
  namespace :admin do
    resources :users
  end
  resources :users
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
end
