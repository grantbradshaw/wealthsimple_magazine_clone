Rails.application.routes.draw do
  get '/', to: 'articles#index'
  get 'articles', to: 'articles#index'
  get 'even_articles', to: 'articles#get_even_articles'
  get 'odd_articles', to: 'articles#get_odd_articles'
end
