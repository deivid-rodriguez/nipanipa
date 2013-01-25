class ActionDispatch::Routing::RouteSet
  def url_for_with_locale_fix(options)
    url_for_without_locale_fix(options.merge(:locale => I18n.locale))
  end

  alias_method_chain :url_for, :locale_fix
end

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
