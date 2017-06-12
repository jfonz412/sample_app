class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # class probably 'require(s)' helper directory
  include SessionsHelper # app/helpers/session_helper.rb

  private

      # Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
