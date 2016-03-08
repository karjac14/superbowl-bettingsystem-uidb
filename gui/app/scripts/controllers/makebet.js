'use strict';

/**
 * @ngdoc function
 * @name bettingsystemApp.controller:MakebetCtrl
 * @description
 * # MakebetCtrl
 * Controller of the bettingsystemApp
 */
var BASE_URL = 'http://localhost:3000';

angular.module('bettingsystemApp')
  .controller('MakebetCtrl',function ($http, $scope) {

    //TODO: This section can be converted to a service
    $scope.game = {};
    $http.get(BASE_URL + '/game')
      .then(function(response){
        $scope.game = response.data.game;
        console.log($scope.game);
      });
    $scope.newBet= {};

    $scope.submitBet = function (){
      console.log($scope.newBet);
      // $http.defaults.headers.post["Access-Control-Allow-Origin"] = "http://localhost:3001/index.html";
      $http.post(BASE_URL + '/newbet', $scope.newBet)
        .then(function(response){
          console.log(response);
        });
    };

    // make sure only one checked
    // TODO: change color image of selected and not selected
    $("input:radio").on('click', function() {
    var selected = $(this);
    if (selected.is(":checked")) {
      $("input:not(selected)").prop("checked", false);
      selected.prop("checked", true);
    }
    });



  });
