module ApiStatusHelpers

  extend ActiveSupport::Concern

  included do
    #
    # Currently, there is no way to handle non-existent ids with cancancan
    # (see https://github.com/CanCanCommunity/cancancan/issues/193), therefore,
    # we have to catch resulting RecordNotFound errors on controller base instead of
    # in each action and generate the resulting response ourselves
    #
    # Feel free to override this rescue in your controller to alter its behaviour
    #
    # TODO: Remove this once cancancan is able to handle this itself
    #
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_api_error :not_found, :record_not_found, exception.message
    end

  end

  protected

  #
  # Renders (usually) an API error response
  #
  # @param [Symbol, Fixnum] status_code
  #   The status code digits or the internal representation (e.g. +:bad_request+),
  #   please refer to the rack documentation for more details
  #
  # @param [Symbol, String] internal_code
  #   Non-Localized internal API code to be interpreted by the frontend which made the request
  #
  # @param [String, ActiveRecord::Base] message
  #   The message to be sent along with the response.
  #   If a record was given, its errors are automatically added to the returned JSON
  #
  def render_api_error(status_code, internal_code = nil, message = nil, additional = {})
    error = ApiError.new(status_code, internal_code, message, additional)
    render :json => error, :status => status_code
  end
end
