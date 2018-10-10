require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = Article.new(:title => 'Why Do Computers Use So Much Energy?',
                          :url => 'https://blogs.scientificamerican.com/observations/why-do-computers-use-so-much-energy/',
                          :image_link => 'https://static.scientificamerican.com/blogs/cache/file/36E8122B-F737-477F-9F3BE740816FAF6F.jpg',
                          :HN_Id => 8392)
  end

  test 'valid article with image_link' do
    assert @article.valid?
  end

  test 'valid article without image_link' do
    @article.image_link = nil
    assert @article.valid?
  end

  test 'invalid without title' do
    @article.title = nil
    refute @article.valid?, 'article is valid without a title'
    assert_not_nil @article.errors[:title], 'no validation error for title present'
  end

  test 'invalid without url' do
    @article.url = nil
    refute @article.valid?, 'article is valid without a url'
    assert_not_nil @article.errors[:url], 'no validation error for url present'
  end

  test 'invalid without HN_Id' do
    @article.HN_Id = nil
    refute @article.valid?, 'article is valid without an HN_Id'
    assert_not_nil @article.errors[:HN_Id], 'no validation error for HN_Id present'
  end

  test 'cannot have two entries with same HN_Id' do
    @article = Article.create(:title => 'Why Do Computers Use So Much Energy?',
                          :url => 'https://blogs.scientificamerican.com/observations/why-do-computers-use-so-much-energy/',
                          :image_link => 'https://static.scientificamerican.com/blogs/cache/file/36E8122B-F737-477F-9F3BE740816FAF6F.jpg',
                          :HN_Id => 8392)
    duplicate_article = @article.dup
    assert_not duplicate_article.valid?
  end

  test 'invalid article url' do
    @article.url = 'The quick brown fox'
    refute @article.valid?, 'article is valid with a url that doesn\'t match a url regex'
    assert_not_nil @article.errors[:url], 'no validation error for url present'
  end

  test 'invalid article image link' do
    @article.image_link = 'The slow green pig'
    refute @article.valid?, 'article is valid with an image_link that doesn\'t match a url regex'
    assert_not_nil @article.errors[:image_link], 'no validation error for image_link present'
  end

  test 'get articles should return array length 30' do
    articles = Article.get_articles
    assert_equal(30, articles.length)
  end

  test 'get articles should return array length 30 if given loaded articles' do
    loaded_articles = Article.get_articles
    articles = Article.get_articles(loaded_articles)
    assert_equal(30, articles.length)
  end

  test 'getting more articles, articles should not overlap with loaded_articles' do
    loaded_articles = Article.get_articles.map {|a| a.HN_Id.to_s}
    articles = Article.get_articles(loaded_articles.dup)
    for new_article in articles
      assert_not_includes(loaded_articles, new_article.HN_Id)
    end
  end

  test 'get articles should return array with article instances' do
    articles = Article.get_articles
    for item in articles do
      assert_instance_of(Article, item)
    end
  end

  test 'get article should return article instance with a valid Hacker News id' do
    hn_article = Article.get_article('8863')
    assert_instance_of(Article, hn_article)
  end

  test 'get article should raise an error if id is invalid' do
    hn_article = Article.get_article('93939393939')
    assert_not_instance_of(Article, hn_article)
  end

  test 'get article should use HN link as URl if no article linked' do
    hn_article = Article.get_article('18164189')
    assert_equal('https://news.ycombinator.com/item?id=18164189', hn_article.url)
  end

  test 'get article image should return image link in meta tag if present for valid uri' do
    image_link = Article.get_article_image("https://blogs.scientificamerican.com/observations/why-do-computers-use-so-much-energy/")
    assert_equal("https://static.scientificamerican.com/blogs/cache/file/36E8122B-F737-477F-9F3BE740816FAF6F.jpg", image_link)
  end

  test 'get article image should return nil if no image link in meta tag for valid uri' do
    image_link = Article.get_article_image("http://www.example.com/")
    assert_nil(image_link)
  end

end


