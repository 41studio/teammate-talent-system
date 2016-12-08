  $('#datetimepicker1').datetimepicker format: 'DD-MM-YYYY HH:mm'
  $('#datetimepicker2').datetimepicker format: 'DD-MM-YYYY HH:mm'
  $('#datetimepicker1').on 'dp.change', (e) ->
    $('#datetimepicker2').data('DateTimePicker').minDate e.date
    return
  $('#datetimepicker2').on 'dp.change', (e) ->
    $('#datetimepicker1').data('DateTimePicker').maxDate e.date
    return
  return