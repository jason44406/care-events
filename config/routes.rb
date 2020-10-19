Rails.application.routes.draw do
  root 'events#index'
  resources :events, only: [:index, :show]
  # get 'events', to: 'events#index'
  # get 'events/:id', to: 'events#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
