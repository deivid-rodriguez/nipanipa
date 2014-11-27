#
# Load Flattr button
#
jQuery ->
  url = '//api.flattr.com/js/0.6/load.js?mode=auto'

  if $('head script[src="' + url + '"]').length == 0
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.async = true
    script.src = url

    $('head').prepend(script)
