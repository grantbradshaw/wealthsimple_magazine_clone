require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = Article.new(:title => 'Why Do Computers Use So Much Energy?',
                          :url => 'https://blogs.scientificamerican.com/observations/why-do-computers-use-so-much-energy/',
                          :image_link => 'https://static.scientificamerican.com/blogs/cache/file/36E8122B-F737-477F-9F3BE740816FAF6F.jpg')
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
    assert_not_nil @article.errors[:title], 'no validation error for url present'
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
end
