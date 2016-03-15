angular.module('philosophers').controller 'AlertsController'
, ['alertsService'
   (alertsService) ->
     new class AlertsController
       alerts: =>
         alertsService.alerts

       clear: =>
         alertsService.alerts = []

       close: (index) =>
         alertsService.closeAlert(index)
  ]
