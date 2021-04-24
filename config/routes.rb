Rails.application.routes.draw do
  root "homes#top"
  namespace :admin do
    resources :users do
      collection do
        get :top
      end
    end
  end
  
  resources :users do
    collection do
      get :top
    end
  end
  resources :requested_shifts
  resources :fixed_shifts

  get       '/login',   to: 'sessions#new'
  post     '/login',   to: 'sessions#create'
  delete   '/logout',  to: 'sessions#destroy'
end
