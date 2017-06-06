module SessionsHelper

	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id #session automatically encrypts this
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def current_user?(user)
		user == current_user # returns true or false
	end

	# Returns the current logged-in user (if any).
	def current_user
		if (user_id = session[:user_id]) #if this is not nil
			@current_user ||= User.find_by(id: user_id) 
		elsif (user_id = cookies.signed[:user_id]) 
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token]) #token passed from browser
				log_in user
				@current_user = user
			end
		end	
	end

  # Returns true if user is not nil
	def logged_in?
		!current_user.nil?
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# logs out user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
end
