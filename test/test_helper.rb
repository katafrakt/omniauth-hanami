ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

path = File.expand_path '../test_app/config.ru', __FILE__
TEST_APP = Rack::Builder.parse_file(path).first
