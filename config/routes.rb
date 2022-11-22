# frozen_string_literal: true

Rails.application.routes.draw do
  resources :bankroll_transactions, except: %i[new show edit]
  resources :poker_sessions, only: %i[show] do
    collection do
      post 'upload'
    end
  end

  match '/date', to: 'hand_histories#by_date', as: 'by_date', via: %i[get post]
  match '/hands', to: 'hands#index', as: 'hands', via: %i[get post]
  match '/positions', to: 'positions#index', as: 'positions', via: %i[get post]
  match '/bet_sizes', to: 'bet_sizes#index', as: 'bet_sizes', via: %i[get post]
  match '/table_sizes', to: 'table_sizes#index', as: 'table_sizes', via: %i[get post]
  match '/stakes', to: 'stakes#index', as: 'stakes', via: %i[get post]
  match '/hand_histories', to: 'hand_histories#index', as: 'hand_histories', via: %i[get post]
  match '/poker_sessions', to: 'poker_sessions#index', as: 'poker_sessions', via: %i[get post]
  match '/villain_hands', to: 'villain_hands#index', as: 'villain_hands', via: %i[get post]
  post '/hh_chart', to: 'hand_histories#chart', as: 'chart_hand_histories'
  get '/ps_chart', to: 'poker_sessions#chart', as: 'chart_poker_sessions'

  root 'index#index'
end
