'use strict';

/**
 * @ngdoc function
 * @name bettingsystemApp.controller:ShowbetsCtrl
 * @description
 * # ShowbetsCtrl
 * Controller of the bettingsystemApp
 */

var BASE_URL = 'http://localhost:3000';

angular.module('bettingsystemApp')
  .controller('ShowbetsCtrl', function ($http, $scope) {
    $scope.bets = {};
    $http.get(BASE_URL + '/bets')
      .then(function(response){
        $scope.bets = response.data.bets.bet;
        console.log($scope.bets);
      });
  });
