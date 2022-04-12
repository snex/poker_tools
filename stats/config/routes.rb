Rails.application.routes.draw do
  match '/date', to: 'hand_histories#by_date', as: 'by_date', via: [:get, :post]
  match '/hands', to: 'hands#index', as: 'hands', via: [:get, :post]
  match '/positions', to: 'positions#index', as: 'positions', via: [:get, :post]
  match '/bet_sizes', to: 'bet_sizes#index', as: 'bet_sizes', via: [:get, :post]
  match '/table_sizes', to: 'table_sizes#index', as: 'table_sizes', via: [:get, :post]
  match '/stakes', to: 'stakes#index', as: 'stakes', via: [:get, :post]
  match '/hand_histories', to: 'hand_histories#index', as: 'hand_histories', via: [:get, :post]
  match '/villain_hands', to: 'villain_hands#index', as: 'villain_hands', via: [:get, :post]
  post '/chart', to: 'hand_histories#chart', as: 'chart_hand_histories'

  root 'index#index'
end
