register = (el) ->
  console.log "registering appear url fol element"
  console.log el
  $el = $(el)
  $spinner = $($el.data("appear-spinner"))
  url = $el.data("appear-url")

  showSpinner = ->
    $spinner.show()
    setTimeout (=> $spinner.removeClass("hidden")), 1
  hideSpinner = ->
    $spinner.hide().addClass("hidden")

  load = ->
    showSpinner()
    console.log url
    $.get url, {}, (response) =>
      $response = $(response)
      $el.append($response)
      $(document).trigger("new-elements", [$response])
    .always =>
      hideSpinner()

  $el.appear(force_process: true).one "appear", load

$ ->
  selector = "[data-appear-url]"
  $(selector).each (_index) -> register(this)