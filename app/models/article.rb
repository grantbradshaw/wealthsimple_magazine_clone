class Article < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true, format: {
    with: /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/,
    message: 'must be a valid url'
  }
  validates :image_link, :allow_blank => true, format: {
    with: /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/,
    message: 'must be a valid url'
  }

  # require 'net/http'
  # require 'json'
  # require 'nokogiri'

  # def index
  #   @articles = []
  # end

  # def get_articles
  #   begin
  #     uri = URI('https://hacker-news.firebaseio.com/v0/topstories.json')
  #     res = Net::HTTP.get(uri)
  #     top_articles = JSON.parse(res)
  #     top_30_articles = top_articles[0,30].map {|a| get_article(a)}
  #     return top_30_articles
  #   rescue => e
  #     puts "failed #{e}"
  #   end
  # end

  # def get_article(id)
  #   begin
  #     uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
  #     res = Net::HTTP.get(uri)
  #     article = JSON.parse(res)

  #     article_url = article["url"]
  #     article_title = article["title"]

  #     return {
  #       :title => article_title,
  #       :url => article_url,
  #       :image => get_article_image(article_url)
  #       # :image => true
  #     }
  #   rescue => e
  #     puts "failed #{e}"
  #   end
  # end

  # def get_article_image(url)
  #   begin
  #     uri = URI(url)
  #     res = Net::HTTP.get(uri)
  #     doc = Nokogiri::HTML(res)

  #     doc.search('head meta').each do |e|
  #       puts e
  #       if e.attribute('property') == 'og:image'
  #         puts e.attribute('content')
  #         return e.attribute('content')
  #       else
  #         return nil
  #       end
  #     end
  #   rescue => e
  #     puts "failed #{e}"
  #     return nil
  #   end
  # end
end
