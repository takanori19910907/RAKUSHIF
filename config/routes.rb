Rails.application.routes.draw do

  root "homes#top"
  
  resources :users do
    collection do
      get :top
    end
  end

  namespace :api, {format: "json"} do
    namespace :v1 do
      namespace :admin do
        resources :users, only: [:index, :show]
        resources :requested_shifts, only: [:index, :create, :update, :destroy]
        resources :fixed_shifts, only: [:index, :create, :update, :destroy]
      end
      namespace :staff do
        resources :users, only: [:index, :show]
        resources :requested_shifts, only: [:index, :create, :update, :destroy]
        resources :fixed_shifts, only: [:index]
      end
    end
  end

  get       "/login",   to: "sessions#new"
  post     "/login",   to: "sessions#create"
  delete   "/logout",  to: "sessions#destroy"
end
