Rails.application.routes.draw do
  resources :documents
  resources :products
  root to: 'documents#new'
end
