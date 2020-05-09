Rails.application.routes.draw do
  root to: "homepages#index"
  resources :trips
  resources :passengers
  resources :drivers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  patch '/drivers/:id/make_available', to: 'drivers#make_available', as: 'driver_available'
end
