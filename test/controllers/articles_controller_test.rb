require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get articles page" do
    get '/articles'
    assert_response :success
  end

  test "should have @articles populated properly on getting articles page" do
    get '/articles'
    assert_equal([], @response.body)
  end
end
