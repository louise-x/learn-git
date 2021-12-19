Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  get 'static_page/home'

  get 'static_page/help'

  resources :microposts
  resources :users
  root 'application#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
