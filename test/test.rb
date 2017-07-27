require_relative 'test_helper'

class MyTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TEST_APP
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello, World!', last_response.body
  end
end
