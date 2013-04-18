require 'rubygems'  
require 'test/unit'  
require 'vcr'
require './lib/glub'

VCR.configure do |c|  
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

class GlubTest < Test::Unit::TestCase  
  def test_create_project 
    VCR.use_cassette('create_project') do
      args = ['create', 'my-test-project', '-c=./test/testconfig']
      response = Glub.start args
      assert_match /.*git remote add origin git@gitlab.com:georgemc\/my-test-project.*/, response
    end
  end
end 
