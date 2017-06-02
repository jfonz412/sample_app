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

	test "login with valid information followed by logout" do
		get login_path
		post login_path, params: { session: { email: 		@user.email,
																					password: 'password' } }
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0 #should be no log in button
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
		# Log out
		delete logout_path #send delete request to logout_path
		assert_not is_logged_in?
		assert_redirected_to root_path
		delete logout_path # Simulate user logging out via second window
		follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
	end

	test "login with remembering" do
		log_in_as(@user, remember_me: '1')
		assert_not_empty cookies['remember_token']
		assert_equal cookies['remember_token'], assigns(:user).remember_token
	end

	test "login without remembering" do 
		# log in to set the cookie
		log_in_as(@user, remember_me: '1')
		# log in again and verifiy that the cookie is deleted
		log_in_as(@user, remember_me: '0')
		assert_empty cookies['remember_token']
	end
end
