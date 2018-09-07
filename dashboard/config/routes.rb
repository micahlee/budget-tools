Rails.application.routes.draw do
  get 'dashboard/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :bank_transactions do
    post 'sync', on: :collection
  end

  resources :ynab do
    post 'sync', on: :collection
  end

  resources :budgets

  root 'dashboard#index'
end
