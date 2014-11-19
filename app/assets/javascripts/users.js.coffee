jQuery ->
  #
  # Set smaller line-height for multiline tips
  #
  cnt = $('#categoriesinfo').height()
  if cnt > 24
    $('#categoriesinfo').css('line-height', '18px')

  cnt = $('#languagesinfo').height()
  if cnt > 24
    $('#languagesinfo').css('line-height', '18px')

  #
  # Load proper regions when country select dropdown changes
  #
  regions = $('#user_region_id').html()

  filter_regions = ->
    country = $('#user_country_id :selected').text()
    escaped_country = country.replace(/([ ,.'[\]])/g, '\\$1')
    options = $(regions).filter("optgroup[label='#{escaped_country}']").html()
    $('#user_region_id').html(options)

  filter_regions()

  $('#user_country_id').change ->
    filter_regions()
