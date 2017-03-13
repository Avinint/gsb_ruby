class Controller
  def current_user
    
    @current_user ||= $gsb_session[:current_user]
  end
end