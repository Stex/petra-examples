window.placeElement = (selector, number, count, radiusModifier, angleModifier = 1, rotate = false) ->
  container = $('#table')
  element   = $(selector)

  width  = container.width()
  height = container.height()

  radius = (width / 2) + ((radiusModifier / 100) * width)
  step   = 2 * Math.PI / count
  angle  = (step / angleModifier) + (number * step)

  x = Math.round(width / 2 + radius * Math.cos(angle) - (element.width() / 2))
  y = Math.round(height / 2 + radius * Math.sin(angle) - (element.height() / 2))

  $(element).css
    left: x + 'px'
    top: y + 'px'

  if rotate
    rotation = number * (360 / count) + step * (180/Math.PI) / 2
    element.css
      transform: "rotate(#{rotation}deg)"
