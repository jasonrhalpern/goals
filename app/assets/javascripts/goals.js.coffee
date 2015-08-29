ready = ->
  $('.reach-by-date').datepicker({format: 'yyyy-mm-dd',  autoclose: true})
  $("#tag-select").select2
    placeholder: "Select Tags"
    allowClear: true

$(document).ready(ready)
$(document).on('page:load', ready)