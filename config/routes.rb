Rails.application.routes.draw do
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

  get '/owner/:id', to: 'misc#redirect_to_owner', as: :owner
end
