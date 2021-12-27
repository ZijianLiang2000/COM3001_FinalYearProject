Rails.application.routes.draw do
  resources :restaurant_data
  resources :maps
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'maps#heatmap'
  get '/map_home' => 'maps#index'
  get '/restaurant_search' => 'restaurant_data#search'
  get 'restaurant_result' => 'restaurant_data#result'
end
