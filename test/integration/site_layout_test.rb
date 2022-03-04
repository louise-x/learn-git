require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
   test "layout links" do
     puts "root_url is #{root_url}"
     puts "root path is #{root_path}"
     assert true
   end
end
