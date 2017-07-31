ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'hanami/model'

db_url = 'sqlite://test/test_app/database.sqlite'
Hanami::Model.configure do
  adapter :sql, db_url
end

require_relative 'database_helper'

DB = Sequel.connect(db_url)
Database.prepare(DB)

path = File.expand_path '../test_app/config.ru', __FILE__
TEST_APP = Rack::Builder.parse_file(path).first
