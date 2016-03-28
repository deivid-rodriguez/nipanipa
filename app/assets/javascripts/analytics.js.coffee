_paq = _paq or []
_paq.push [ 'trackPageView' ]
_paq.push [ 'enableLinkTracking' ]

do ->
  u = '//192.81.212.5/piwik/'

  _paq.push [
    'setTrackerUrl'
    u + 'piwik.php'
  ]

  _paq.push [
    'setSiteId'
    1
  ]

  d = document
  g = d.createElement('script')
  s = d.getElementsByTagName('script')[0]

  g.type = 'text/javascript'
  g.async = true
  g.defer = true
  g.src = u + 'piwik.js'

  s.parentNode.insertBefore g, s
  return
