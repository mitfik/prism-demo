require 'test/unit'
require 'rack/test'

ENV['CONFIG_FILE'] = "tests/config/database.yml"
OUTER_APP = Rack::Builder.parse_file('config.ru').first

class PrismTest < Test::Unit::TestCase
 include Rack::Test::Methods

 def app
   OUTER_APP
 end

 def test_root
   get '/'
   assert last_response.ok?
 end

 def test_load_config
   assert app.settings.database_uri.include?("postgres://")
 end

end
