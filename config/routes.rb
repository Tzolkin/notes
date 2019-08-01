Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#main'

  resource :folder, only: %i(create show)
  resource :note, only: %i(create show)

  get '*folders/:name', controller: 'item', action: 'show'
  get '/:name', controller: 'item', action: 'show'
end
