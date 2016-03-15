angular.module('philosophers').directive 'stick'
, ['$templateRequest', '$compile', '$window',
    ($templateRequest, $compile, $window) ->
      {
        restrict: 'E',
        link: (scope, element) ->
          $templateRequest("sticks/_stick.html").then (html) =>
            template = angular.element(html)
            element.append(template)

            resizeFun = () =>
              placeElement template
              , scope.stick.number
              , scope.sticksCtrl.sticks().length
              , -10
              , 2
              , true

            resizeFun()

            angular.element($window).bind 'resize', () =>
              resizeFun()

            $compile(template)(scope)
      }
]

angular.module('philosophers').directive 'stickButton', [() ->
  {
    restrict: 'E',
    templateUrl: 'sticks/_stick_button.html',
    controller: 'SticksCtrl',
    controllerAs: 'sticksCtrl',
    scope:
      position: '@'
  }
]

angular.module('philosophers').directive 'commitButton', [() ->
  {
    restrict: 'E',
    templateUrl: 'sticks/_commit_button.html',
    controller: 'SticksCtrl',
    controllerAs: 'sticksCtrl'
  }
]
