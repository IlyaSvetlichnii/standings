Rails.application.routes.draw do
  root 'tournaments#index'

  post 'tournaments/division_result'
  post 'tournaments/play_off_result'
  # get 'tournaments/new'
  # get 'tournaments/create'
  get 'tournaments/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
