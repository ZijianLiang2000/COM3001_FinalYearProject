Rails.application.routes.draw do
  resources :district_data
  resources :restaurant_data
  resources :maps
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'maps#home'
  get 'home' => 'maps#home'
  # Heatmap for LSOA
  get 'lsoa_heatmap' => 'maps#lsoa_heatmap'
  post 'lsoa_heatmap' => 'maps#lsoa_heatmap'
  # Heatmap for LAD
  get 'lad_heatmap' => 'maps#lad_heatmap'
  post 'lad_heatmap' => 'maps#lad_heatmap'
  # Heatmap for LAD
  get 'user_option' => 'maps#user_option'
  # Heatmap for Clusters
    # Heatmap for LSOA
  get 'rest_cluster' => 'maps#rest_cluster'
  post 'rest_cluster' => 'maps#rest_cluster'
  
  get 'restaurant_search' => 'restaurant_data#search'
  get 'restaurant_result' => 'restaurant_data#result'
  # get 'google_result' => 'restaurant_data#google_result'
  # post 'google_result_next' => 'restaurant_data#google_result_next'
  # get 'google_result_next' => 'restaurant_data#google_result_next'
  post 'nearby_result' => 'maps#nearby_result'
  get 'nearby_result' => 'maps#nearby_result'
  get 'get_restaurant_count' => 'maps#get_restaurant_count'
  get 'get_rest_detail' => 'maps#get_rest_detail'
end
