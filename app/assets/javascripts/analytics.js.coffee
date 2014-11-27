#
# Load Piwik Analytics
#
jQuery ->
  _paq = _paq or []
  _paq.push(['trackPageView'])
  _paq.push(['enableLinkTracking'])

  url = '//192.81.212.5/piwik/piwik.js'

  if $('head script[src="' + url + '"]').length == 0
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.async = true
    script.src = url

    $('head').prepend(script)
