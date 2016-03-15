require 'api_error'

class ApplicationController < ActionController::Base
  include ApiStatusHelpers
  include Petra::Rails::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_philosopher

  protected

  def current_philosopher
    @current_philosopher ||= Philosopher.find_by(:session_id => session.id)
  end
end
