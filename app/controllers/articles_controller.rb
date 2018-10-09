class ArticlesController < ApplicationController

  def index
    # @articles = Article.get_articles
    @articles = [1,2,3,4,5]
  end

  def get_even_articles

  end

  def get_odd_articles

  end
end
