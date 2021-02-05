Rails.application.routes.draw do
  root to: 'static_pages#root'

  resources :buildings
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :buildings
  resources :rooms
  resources :boxes
  resources :devices do
    resources :interfaces
  end
  resources :logical_links, except: [:edit, :update] # Объекты Relationship нельзя редактировать
  resources :patchcords, except: [:edit, :update]
  resources :cables
  resources :patchpanels do
    resources :interfaces
    post 'interfaces/generate', to: 'interfaces#generate'
  end

  get '/box_children/:id', to: 'misc#box_children'
  get '/get_interfaces/:id', to: 'misc#get_interfaces'
  get '/get_patchpanels/:id', to: 'misc#get_patchpanels'
  get '/get_boxes/:id', to: 'misc#get_boxes'

  get '/owner/:id', to: 'misc#redirect_to_owner', as: :owner

  post '/search', to: 'misc#search', as: :search

  get 'import/devices', to: 'imports#devices', as: :import_devices
  post 'import/devices', to: 'imports#load_devices'

  get 'import/patchpanels', to: 'imports#patchpanels', as: :import_patchpanels
  post 'import/patchpanels', to: 'imports#load_patchpanels'

  get 'import/logical_links', to: 'imports#logical_links', as: :import_logical_links
  post 'import/logical_links', to: 'imports#load_logical_links'

  get 'import/cables', to: 'imports#cables', as: :import_cables
  post 'import/cables', to: 'imports#load_cables'

  get 'import/patchcords', to: 'imports#patchcords', as: :import_patchcords
  post 'import/patchcords', to: 'imports#load_patchcords'
end
