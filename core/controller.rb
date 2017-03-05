class Controller
  def current_user
    return unless $gsb_session[:current_user]
    @current_user ||= $gsb_session[:current_user]
  end
end