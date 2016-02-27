#
# User related js functionality
#
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
  $('#user_country').change ->
    url = $(this).data('regions-url').replace(':country_id', $(this).val())
    $('#user_region_id').empty()
    $.getJSON url, (data) ->
      $.each data, (index, el) ->
        [id, name] = [el.id, el.name]
        $('#user_region_id').append("<option value='#{id}'>#{name}</option>")
