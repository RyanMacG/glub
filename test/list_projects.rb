require 'rubygems'  
require 'test/unit'  
require 'vcr'
require './lib/glub'

VCR.configure do |c|  
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

class ListProjectTest < Test::Unit::TestCase  
  def test_list_projects 
    VCR.use_cassette('list_projects') do
      args = ['list', '-c=./test/testconfig']
      response = Glub.start args
      assert_match /my-test-project/, response
    end
  end
end 
