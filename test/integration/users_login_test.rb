require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end

	test "login with invalid information" do
		get login_path # visit login path
		assert_template 'sessions/new' # make sure sessions form renders properly
		post login_path, params: { session: { email: "", password: "" } } # post invalid params 
		assert_template 'sessions/new' # verify new sessions form gets rendered... 
		assert_not flash.empty? # ...and that flash will appear
		get root_path # visit another page
		assert flash.empty? # verify that the flash doesn't appear on new page
	end

	test "login with valid information" do
		get login_path
		post login_path, params: { session: { email: 		@user.email,
																					password: 'password' } }
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0 #should be no log in button
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
	end
end
