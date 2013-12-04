require 'test/unit'
require 'rack/test'
require 'json'

ENV['CONFIG_FILE'] = "tests/config/database.yml"
OUTER_APP = Rack::Builder.parse_file('config.ru').first
# Clear database before tests
DataMapper.auto_migrate!

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

 def test_companies
    get '/companies'
    companies = JSON.parse(last_response.body)
    assert_equal 1, companies.count
 end

 def test_add_new_company
    company = {:name => "NASA", :address => "Kalingrad", :city => "Huston",
               :country => "Denmark" }
    post '/company', company.to_json, "CONTENT_TYPE" => "application/json"
    response = JSON.parse(last_response.body)
    assert_equal response["company"]["status"], "OK"
 end

 def test_fail_adding_new_company
     company = {:name => "", :address => "Kalingrad", :city => "",
                :country => "Denmark", :email => "prism@usa.gov.com"}
    post '/company', company.to_json, "CONTENT_TYPE" => "application/json"
    response = JSON.parse(last_response.body)
    assert_equal 2, response["company"]["errors"].count
 end

 def test_fetch_company_by_id
    get '/company/1'
    assert last_response.body.include?("NASA")
 end

 def test_404
   get '/company/666'
   assert_equal last_response.status, 404
 end

 def test_400
     company = {:lastname => "", :address => "Kalingrad", :city => "",
                :country => "Denmark", :email => "prism@usa.gov.com"}
    post '/company', company.to_json, "CONTENT_TYPE" => "application/json"
    assert_equal last_response.status, 400
 end

end
