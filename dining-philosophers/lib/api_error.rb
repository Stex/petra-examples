# @restful_api v1
#
# Represents an API error which is sent back to the client through JSON
#
# While an API error may have additional fields which are specific to the
# action which was triggered, `code` and `message` are set most of the time.
#
# @attr [String] status
#   A status string which is always set to `error` to ensure compatibility
#   to devise's JSON functionality. May therefore be ignored for everything
#   that't not devise-related.
#
# @attr [String, Symbol] code
#   An internal error code used by the client to determine what exactly went wrong
#   without having to worry about localization (e.g. `no_query_given`)
#
# @attr [String, ActiveRecord::Base] message
#   An already localized message specifying what went wrong during the request or an instance
#   of ActiveRecord::Base. If the later was given, an errors hash is automatically generated
#   and added to the resulting JSON
#
class ApiError

  def initialize(status_code, internal_code, message = nil, options = {})
    @status_code       = status_code

    @options           = options
    @options[:code]    = internal_code

    if message.is_a?(ActiveRecord::Base)
      @options[:errors] = message.errors.to_hash.merge(full_messages: message.errors.full_messages)
    end

    @options[:message] = message if message
    @options[:status]  = 'error'
  end

  def as_json(options = {})
    @options.as_json(options)
  end

end
