require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should return 30 articles from Hacker News" do
    articles = HackerNews.getArticles()
    assert_equal(articles.length, 30)
  end

end
