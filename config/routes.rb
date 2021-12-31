Rails.application.routes.draw do
  resources :restaurant_data
  resources :maps
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'maps#home'
  get 'home' => 'maps#home'
  get 'heatmap' => 'maps#heatmap'
  get 'restaurant_search' => 'restaurant_data#search'
  get 'restaurant_result' => 'restaurant_data#result'
  get 'google_result' => 'restaurant_data#google_result'
  post 'google_result_next' => 'restaurant_data#google_result_next'
  get 'google_result_next' => 'restaurant_data#google_result_next'
end
