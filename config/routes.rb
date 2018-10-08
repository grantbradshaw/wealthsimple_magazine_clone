Rails.application.routes.draw do
  # get 'home/index'
  get 'articles/index'

  root 'articles#index'
end
