Rails.application.routes.draw do
  root 'tournaments#index'

  post   'tournaments/division_result'
  post   'tournaments/play_off_result'
  get    'tournaments/new'
  post   'tournaments/create'
  get    'tournaments/show'
  delete 'tournaments/destroy'

  get  'teams/new'
  post 'teams/create'
end
