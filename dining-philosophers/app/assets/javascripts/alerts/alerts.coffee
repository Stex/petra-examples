angular.module('philosophers').service 'alertsService'
, ['$http', '$interval',
    ($http, $interval) ->
      new class AlertsService
        constructor: ->
          @alerts = []

        addAlert: (type, message) =>
          @alerts.push
            'type': type
            'message': message

        closeAlert: (index) =>
          @alerts.splice(index, 1)
]

