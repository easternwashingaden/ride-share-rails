Rails.application.routes.draw do
  root to: "homepages#index"
  resources :trips
  resources :passengers
  resources :drivers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  patch '/drivers/:id/toggle_available', to: 'drivers#toggle_available', as: 'driver_available'
end
