angular.module('philosophers').directive 'philosopher'
, ['$templateRequest', '$compile', '$window',
    ($templateRequest, $compile, $window) ->
      {
        restrict: 'E',
        link: (scope, element) ->
          $templateRequest("philosophers/_philosopher.html").then (html) =>
            template = angular.element(html)
            element.append(template)

            resizeFun = () =>
              placeElement template
              , scope.philosopher.number
              , scope.philCtrl.philosophers().length
              , 15
              , 1

            resizeFun()

            angular.element($window).bind 'resize', resizeFun

            $compile(template)(scope)
      }
]

angular.module('philosophers').directive 'plate'
, ['$templateRequest', '$compile', '$window',
    ($templateRequest, $compile, $window) ->
      {
        restrict: 'E',
        link: (scope, element) ->
          $templateRequest("philosophers/_plate.html").then (html) =>
            template = angular.element(html)
            element.append(template)

            resizeFun = () =>
              placeElement template
              , scope.philosopher.number
              , scope.philCtrl.philosophers().length
              , -15
              , 1
              , true

            resizeFun()
            angular.element($window).bind 'resize', resizeFun

            $compile(template)(scope)
      }
]

angular.module('philosophers').directive 'philosophersList', [() ->
  {
    restrict: 'E',
    templateUrl: 'philosophers/_list.html',
    controller: 'PhilosophersCtrl',
    controllerAs: 'philCtrl'
  }
]

angular.module('philosophers').directive 'leaveButton', [() ->
  {
    restrict: 'E',
    templateUrl: 'philosophers/_leave_button.html',
    controller: 'PhilosophersCtrl',
    controllerAs: 'philCtrl'
  }
]

angular.module('philosophers').directive 'thinkButton', [() ->
  {
    restrict: 'E',
    templateUrl: 'philosophers/_think_button.html',
    controller: 'PhilosophersCtrl',
    controllerAs: 'philCtrl'
  }
]
