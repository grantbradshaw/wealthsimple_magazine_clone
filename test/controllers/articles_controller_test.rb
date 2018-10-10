require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get articles page" do
    get '/articles'
    assert_response :success
  end
end
