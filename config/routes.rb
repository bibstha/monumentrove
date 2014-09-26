Rails.application.routes.draw do

  devise_for :users
  resources :collections
  resources :categories
  resources :monuments do
    resources :pictures
    get "coverflow", to: "monument#coverflow"
  end

  get 'search', to: 'search#search', as: 'search'

  devise_scope :user do
    root to: "devise/sessions#new"
  end
  
end
