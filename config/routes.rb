Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'teams#index'

  resources :teams do
    resources :spirit_score_sheet
  end
  resources :divisions
end
