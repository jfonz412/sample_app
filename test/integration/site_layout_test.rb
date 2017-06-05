require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
	end

	test "layout links" do
		get root_path
		assert_template 'static_pages/home' # checks proper template has been rendered
		assert_select "a[href=?]", root_path, count: 2 # selects an html element
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", contact_path

		get contact_path
		assert_select "title", full_title("Contact")

		get signup_path
		assert_template 'users/new'
		assert_select "title", full_title("Sign up")
	end

	test "links when logged in" do
		get root_path
		log_in_as(@user)
		follow_redirect!
		assert_select "a[href=?]", users_path
		assert_select "a[href=?]", user_path
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", contact_path
		assert_select "a[href=?]", edit_user_path
		assert_select "a[href=?]", logout_path
	end
end
