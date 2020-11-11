require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username: 'admin-article-creator', email: 'admin@example.com', password: '123456', admin: true)
    @regular_user = User.create(username: 'regular-article-creator', email: 'regular@example.com', password: '123456', admin: false)
  end

  test "get new article form and create article as admin" do
    sign_in_as(@admin_user)
    get new_article_path
    assert_response :success
    assert_difference 'Article.count',1 do
      post articles_path, params: { article: { title: 'New Article Title', description: 'New article description.' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'New Article Title', response.body
    assert_match 'New article description.', response.body
    assert_match 'admin-article-creator', response.body
  end

  test "get new article form and create article as regular user" do
    sign_in_as(@regular_user)
    get new_article_path
    assert_response :success
    assert_difference 'Article.count',1 do
      post articles_path, params: { article: { title: 'Another New Article Title', description: 'Another New article description.' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Another New Article Title', response.body
    assert_match 'Another New article description.', response.body
    assert_match 'regular-article-creator', response.body
  end
end
