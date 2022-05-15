Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'teams#index'

  resources :teams
  resources :spirit_score_sheets
  resources :divisions
end
