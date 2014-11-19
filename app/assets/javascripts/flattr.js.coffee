#
# Load Flattr button asyncronously
#
jQuery ->
  s = document.createElement('script')
  t = document.getElementsByTagName('script')[0]

  s.type = 'text/javascript'
  s.async = true
  s.src = '//api.flattr.com/js/0.6/load.js?mode=auto'

  t.parentNode.insertBefore(s, t)
