angular.module 'philosophers', ['templates', 'ui.bootstrap']
.config [
  '$httpProvider'
  ($httpProvider) ->
    csrfParam = $('meta[name=csrf-param]').attr("content")
    csrfValue = $('meta[name=csrf-token]').attr("content")

    $httpProvider.defaults.transformRequest.unshift (data, headersGetter) ->
      data ||= {}
      return data unless typeof data == 'object'
      data[csrfParam] = csrfValue
      data

]
