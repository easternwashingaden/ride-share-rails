Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "homepages#index"
  resources :passengers

  resources :drivers
  patch '/drivers/:id/toggle_available', to: 'drivers#toggle_available', as: 'driver_available'
  
  post "passengers/:id/trips", to: "trips#create", as: "trips"
  get "trips/:id/edit", to: "trips#edit", as: "edit_trip"
  get "trips/:id", to: "trips#show", as: "trip"
  patch "trips/:id", to: "trips#update" 
  delete "trips/:id", to: "trips#destroy"
end
