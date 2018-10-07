class ApplicationController < ActionController::Base
  before_action :authorize

  protected

  def authorize
    unless request.format.html?
      authenticate_or_request_with_http_basic('Admin') do |username, password|
        user = User.find_by(name: username)
        if user.try(:authenticate, password) ||
          user&.authenticate(params[:password]) # same thing diff syntax
          session[:user_id] = user.id
        end
      end
    end
    unless User.find_by(id: session[:user_id])
      respond_to do |format|
        format.html { redirect_to login_url, notice: 'Please log in' }
        format.json { render json: 'Not authorized', status: 401 }
        format.atom { render json: 'Not authorized', status: 401 }
        return unless request.format.html?
      end
    end
  end
end
