class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # class probably 'require(s)' helper directory
  include SessionsHelper # app/helpers/session_helper.rb
end
