Rails.application.routes.draw do
  namespace :user do
    get 'investments/new'
  end

  namespace :user do
    get 'investments/index'
  end

  namespace :user do
    get 'investments/show'
  end

  get 'home/index'
  get 'home/value_calculator'

  devise_for :users

  root :to => 'home#index'

  namespace :user do
    # #@todo add destroy and update for
    resources :investments, only: [:index, :show, :new, :create]
  end
end
