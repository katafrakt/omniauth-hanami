require_relative 'test_helper'

class MyTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TEST_APP
  end

  def url
    '/auth/hanami/callback'
  end

  def incorrect_credentials
    { user: { email: 'aaa@wp.pl', password: 'xyz123' } }
  end

  def correct_credentials
    { user: { email: 'test@user.com', password: 'abc123xd' } }
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello, World!', last_response.body
  end

  def test_redirect_on_wrong_credentials
    post url, incorrect_credentials
    assert_equal 302, last_response.status
    redir_url = '/auth/failure?message=invalid_credentials&strategy=hanami'
    assert_equal redir_url, last_response.headers['Location']
    refute last_response.ok?
  end

  def test_redirect_on_correct_credentials
    post url, correct_credentials
    assert_equal 302, last_response.status
    assert_equal '/', last_response.headers['Location']
  end
end
