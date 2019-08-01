Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#main'

  resource :folder, only: %i(create)
  resource :note, only: [:create]

  get '*folders/:name', controller: 'notes', action: 'show'
  get '/:name', controller: 'notes', action: 'show'
end
