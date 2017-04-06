
class Auth

	def self.login user, password
		@user = user
		# object password before string password
		 user.verify_password == password ? authenticate : false
	end

	def self.authenticate
		$gsb_session[:current_user] = @user
	end

	def self.logout
		$gsb_session[:current_user].token = nil
		#$gsb_session[:current_user].save
		$gsb_session[:current_user] = nil
	end
end