describe 'ngUnique', ->
  beforeEach(module('DucksuiteApp'))

  beforeEach inject ($compile, $rootScope, $document)->
    $body = angular.element($document[0].body)
    $form = angular.element('<form name="testForm" novalidate/>')
    $el = angular.element('<input type="text" name="test" unique ng-model="test"/>')
    $rootScope.data = {}
    $rootScope.data.user =
      domains: [{ name: 'domain.com' }]
    $form.append($el)
    $body.append($form)

    $compile($form)($rootScope)

    $rootScope.$digest()

  describe 'with the same domain name', ->
    it 'sets form as invalid', inject ($compile, $rootScope, $document)->
      $rootScope.testForm.test.$setViewValue 'domain.com'
      expect($rootScope.testForm.$valid).toBeFalsy()

  describe 'with different domain name', ->
   it 'sets form as valid', inject ($compile, $rootScope, $document)->
    $rootScope.testForm.test.$setViewValue 'differentdomain.com'
    expect($rootScope.testForm.$valid).toBeTruthy()
