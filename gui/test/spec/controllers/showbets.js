'use strict';

describe('Controller: ShowbetsCtrl', function () {

  // load the controller's module
  beforeEach(module('bettingsystemApp'));

  var ShowbetsCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    ShowbetsCtrl = $controller('ShowbetsCtrl', {
      $scope: scope
      // place here mocked dependencies
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(ShowbetsCtrl.awesomeThings.length).toBe(3);
  });
});
