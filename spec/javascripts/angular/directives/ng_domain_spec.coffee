describe 'ngDomain', ->
  beforeEach(module('DucksuiteApp'))

  beforeEach inject ($compile, $rootScope, $document)->
    $body = angular.element($document[0].body)
    $form = angular.element('<form name="testForm" novalidate/>')
    $el = angular.element('<input type="text" name="test" domain ng-model="test"/>')
    $form.append($el)
    $body.append($form)

    $compile($form)($rootScope)

    $rootScope.$digest()

  describe 'with wrong domain format', ->
    it 'sets form as invalid', inject ($compile, $rootScope, $document)->
      $rootScope.testForm.test.$setViewValue 'wrong value'
      expect($rootScope.testForm.$valid).toBeFalsy()

  describe 'with proper domain format', ->
   it 'sets form as valid', inject ($compile, $rootScope, $document)->
    $rootScope.testForm.test.$setViewValue 'domain.com'
    expect($rootScope.testForm.$valid).toBeTruthy()
