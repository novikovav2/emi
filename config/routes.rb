Rails.application.routes.draw do
  resources :buildings
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :buildings
  resources :rooms
  resources :boxes
  resources :devices do
    resources :interfaces, except: [:index]
  end
  resources :logical_links, except: [:edit, :update] # Объекты Relationship нельзя редактировать
  resources :patchcords, except: [:edit, :update]
  resources :cables
  resources :patchpanels do
    resources :interfaces
  end
end
