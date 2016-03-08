'use strict';

/**
 * @ngdoc function
 * @name bettingsystemApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the bettingsystemApp
 */



var BASE_URL = 'http://localhost:3000';

angular.module('bettingsystemApp')
  .controller('MainCtrl', function ($http, $scope) {
    $scope.game = {};
    $http.get(BASE_URL + '/game')
      .then(function(response){
        $scope.game = response.data.game;
        console.log($scope.game);
      });
  });
