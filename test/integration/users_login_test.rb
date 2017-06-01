require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	test "login with invalid information" do
		get login_path # visit login path
		assert_template 'sessions/new' # make sure sessions form renders properly
		post login_path, params: { session: { email: "", password: "" } } # post invalid params 
		assert_template 'sessions/new' # verify new sessions form gets rendered... 
		assert_not flash.empty? # ...and that flash will appear
		get root_path # visit another page
		assert flash.empty? # verify that the flash doesn't appear on new page
	end
end
