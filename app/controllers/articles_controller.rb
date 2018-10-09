class ArticlesController < ApplicationController

  def index
    # @articles = Article.get_articles
    @articles = [1,2,3,4,5]
  end

  def get_even_articles

  end

  def get_odd_articles

  end

  def more_articles
    @articles = [1,2,3,4,5,6,7,8,9,10]
  end
end
