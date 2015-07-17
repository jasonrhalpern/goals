ready = ->
  $('.reach-by-date').datepicker({format: 'yyyy-mm-dd',  autoclose: true})

$(document).ready(ready)
$(document).on('page:load', ready)