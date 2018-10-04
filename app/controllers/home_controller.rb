class HomeController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    @articles = get_articles
  end

  def get_articles
    begin
      uri = URI('https://hacker-news.firebaseio.com/v0/topstories.json')
      res = Net::HTTP.get(uri)
      top_articles = JSON.parse(res)
      top_30_articles = top_articles[0,30].map {|a| get_article(a)}
      return top_30_articles
    rescue => e
      puts "failed #{e}"
    end
  end

  def get_article(id)
    uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
    res = Net::HTTP.get(uri)
    article = JSON.parse(res)
    return {
      :title => article["title"],
      :url => article["url"]
    }
  end

end
