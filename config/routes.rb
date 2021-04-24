Rails.application.routes.draw do
  root "homes#top"
  namespace :admin do
    resources :requested_shifts
    resources :fixed_shifts
    resources :users do
      collection do
        get :top
      end
    end
  end
  
  namespace :staff do
    resources :requested_shifts
    resources :fixed_shifts
    resources :users do
      collection do
        get :top
      end
    end
  end

  get       '/login',   to: 'sessions#new'
  post     '/login',   to: 'sessions#create'
  delete   '/logout',  to: 'sessions#destroy'
end
