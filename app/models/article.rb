require 'net/http'
require 'json'
require 'nokogiri'

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

  private

  def self.get_articles(loaded_articles = nil)
    begin
      uri = URI('https://hacker-news.firebaseio.com/v0/topstories.json')
      res = Net::HTTP.get(uri)
      top_articles = JSON.parse(res)
    rescue => e
      puts "failed #{e}"
    end

    if loaded_articles
      articles_to_process = 60
      articles = loaded_articles
    else
      articles_to_process = 30
      articles = []
    end

    for i in 0..(top_articles.length - 1) do
      article = self.get_article(top_articles[i], loaded_articles)
      if article
        articles.push(article)
      end

      if articles.length >= articles_to_process
        break
      end
    end

    articles

  end

  def self.get_article(id, loaded_articles=nil)
    begin
      uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
      res = Net::HTTP.get(uri)
    rescue => e
      puts "failed #{e}"
      return nil
    end

    # hacker news api returns string 'null' if invalid id
    if res === 'null'
      return nil
    end

    article_json = JSON.parse(res)

    if article_json.key?('url')
      article_url = article_json["url"] # consider validation on whether url is valid, currently trusting HN api to provide valid uris
    else
      article_url = "https://news.ycombinator.com/item?id=#{id}"
    end

    if loaded_articles && loaded_articles.select {|a| a.url == article_url}.length > 0
      return nil
    end

    article_title = article_json["title"]
    if /^https:\/\/news\.ycombinator\.com\/item\?id=[0-9]+$/.match?(article_url)
      article_image = nil
    else
      article_image = self.get_article_image(article_url)
    end

    article = self.new({:url => article_url,
                        :title => article_title,
                        :image_link => article_image})
    if article.save
      article
    else
      nil
    end
  end

  # for runtime performance, look at querying database before scraping webpages
  # should check for other meta image tags (i.e. for twitter) if og:image not present
  def self.get_article_image(url)
    begin
      uri = URI(url)
      res = Net::HTTP.get(uri)
      doc = Nokogiri::HTML(res)
    rescue => e
      puts "failed #{e}"
      return nil
    end

    image_link = nil

    doc.search('head meta').each do |ele|
      if ele['property'] == "og:image"
        image_link = ele['content']
      end
    end

    image_link
  end
end
