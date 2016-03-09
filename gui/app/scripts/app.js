'use strict';

/**
 * @ngdoc overview
 * @name bettingsystemApp
 * @description
 * # bettingsystemApp
 *
 * Main module of the application.
 */
angular
  .module('bettingsystemApp', [
    'ngRoute'
  ])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl',
        controllerAs: 'main'
      })
      .when('/makebet', {
        templateUrl: 'views/makebet.html',
        controller: 'MakebetCtrl',
        controllerAs: 'makebet'
      })
      .when('/showbets', {
        templateUrl: 'views/showbets.html',
        controller: 'ShowbetsCtrl',
        controllerAs: 'showbets'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
