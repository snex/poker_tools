Rails.application.routes.draw do
  resources :positions, :bet_sizes, :table_sizes, only: [:index]

  get '/date', to: 'hand_histories#by_date', as: 'by_date'
  match '/hands', to: 'hands#index', as: 'hands', via: [:get, :post]
  match '/hand_histories', to: 'hand_histories#index', as: 'hand_histories', via: [:get, :post]
  post '/chart', to: 'hand_histories#chart', as: 'chart_hand_histories'

  root 'index#index'
end
