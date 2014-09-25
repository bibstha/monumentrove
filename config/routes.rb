Rails.application.routes.draw do

  devise_for :users
  resources :collections
  resources :categories
  resources :monuments do
    resources :pictures
  end

  get 'search', to: 'search#search', as: 'search'

  devise_scope :user do
    root to: "devise/sessions#new"
  end
  
end
