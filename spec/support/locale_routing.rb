class ActionController::TestCase
  module Behavior
    def process_with_default_locale(action, parameters = nil,
                                            session = nil,
                                            flash = nil,
                                            http_method = 'GET')
      parameters = { :locale => I18n.default_locale }.merge( parameters || {} )
      process_without_default_locale(action, parameters,
                                             session,
                                             flash,
                                             http_method)
    end
    alias_method_chain :process, :default_locale
  end
end

class ActionController::Integration::Session
  def url_for_with_default_locale(options)
    options = { :locale => I18n.default_locale }.merge(options)
    url_for_without_default_locale(options)
  end
  alias_method_chain :url_for, :default_locale
end
