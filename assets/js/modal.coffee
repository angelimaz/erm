scrollLocker = require("./scroll_locker")

$ ->
  console.log "init data modal links"
  selector = "[data-modal]"
  $modal = $(".modal")
  $content = $modal.find(".modal-content")
  $spinner = $modal.find(".modal-spinner")
  $error = $modal.find(".modal-error")

  destroy = ->
    $modal.hide()
    scrollLocker.clearAll()
    $content.empty()

  closeModal = (event) ->
    console.log "close modal"
    $modal.removeClass("is-active")
    setTimeout (-> destroy()), 700
    event.preventDefault()

  triggerUpdated = ->
    $(document).trigger("modal:load", $modal)
    $(document).trigger("new-elements", $modal)

  get = (url) ->
    console.log "get called for modal"
    $spinner.show()
    $.get url, (data) ->
      $content.html(data)
      triggerUpdated()
    .fail ->
      $error.show()
    .always ->
      $spinner.hide()

  copy = (selector) ->
    $el = $(selector).clone().show()
    $content.empty().append($el)
    triggerUpdated()

  $(document).on "click", ".modal .close", closeModal
  $(document).keyup (event) -> if event.keyCode == 27 then closeModal(event)

  $(document).on "click", selector, (event) ->
    console.log "link with modal clicked"
    $el = $(event.target).closest(selector)
    urlOrSelector = $el.data("modal")
    isSelector = urlOrSelector.startsWith("#") || urlOrSelector.startsWith(".")
    $error.hide()

    if isSelector
      copy(urlOrSelector)
    else
      $content.empty()
      get(urlOrSelector)

    $modal.show()
    $modal.toggleClass('is-active')
    scrollLocker.enable($modal)
    setTimeout (-> $modal.toggleClass('is-active')), 100
    $el.trigger("modal:show")

    event.preventDefault()