# Fixes the missing default locale problem in request specs
# See http://www.ruby-forum.com/topic/3448797
class ActionView::TestCase::TestController
  def default_url_options(options={})
    { :locale => I18n.default_locale }
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    { :locale => I18n.default_locale }
  end
end

# Fixes the missing default locale problem in controller specs
# See http://www.ruby-forum.com/topic/3448797#1041659
class ActionController::TestCase
  module Behavior
    def process_with_default_locale(action, parameters = nil,
                                            session = nil,
                                            flash = nil,
                                            http_method = 'GET')
      parameters = {
        :locale => I18n.default_locale
      }.merge( parameters || {} )
      process_without_default_locale(action, parameters,
                                             session,
                                             flash,
                                             http_method)
    end
    alias_method_chain :process, :default_locale
  end
end

module ActionDispatch::Assertions::RoutingAssertions
  def assert_recognizes_with_default_locale(expected_options, path,
                                                              extras = {},
                                                              message=nil)
    expected_options = {
      :locale => I18n.default_locale.to_s
    }.merge(expected_options || {} )
    assert_recognizes_without_default_locale(expected_options, path,
                                                               extras,
                                                               message)
  end
  alias_method_chain :assert_recognizes, :default_locale
end

class ActionController::Integration::Session
  def url_for_with_default_locale(options)
    options = { :locale => I18n.default_locale }.merge(options)
    url_for_without_default_locale(options)
  end
  alias_method_chain :url_for, :default_locale
end

# Fixes translations from specs
I18n.locale = I18n.default_locale
def t(string, options = {})
  I18n.t(string, I18n.locale, options)
end
