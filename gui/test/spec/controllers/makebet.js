'use strict';

describe('Controller: MakebetCtrl', function () {

  // load the controller's module
  beforeEach(module('bettingsystemApp'));

  var MakebetCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    MakebetCtrl = $controller('MakebetCtrl', {
      $scope: scope
      // place here mocked dependencies
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(MakebetCtrl.awesomeThings.length).toBe(3);
  });
});
