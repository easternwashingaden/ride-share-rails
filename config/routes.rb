Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "homepages#index"
  resources :passengers

  resources :drivers
  patch '/drivers/:id/toggle_available', to: 'drivers#toggle_available', as: 'driver_available'
  
  post "passengers/:id/trips", to: "trips#create", as: "trips"
  resources :trips, except: [:index, :new, :create]
end
