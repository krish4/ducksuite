describe 'UpdateUserCtrl', ->
  scope = undefined
  ctrl = undefined
  $httpBackend = undefined

  beforeEach(module('DucksuiteApp'))

  beforeEach(inject( (_$httpBackend_, $rootScope, $controller, _$compile_) ->
    $httpBackend = _$httpBackend_
    $compile = _$compile_
    scope = $rootScope.$new()
    ctrl = $controller('UpdateUserCtrl', { $scope: scope })
    # Request for logging user in
    $httpBackend.expectPOST('/users/sign_in.json', {"user": {}}).respond({})
    # Request for getting current user
    $httpBackend.expectGET("/api/users").respond({user: {id: 1, name: "Jackie Chan", email: "jackiechan@test.com"}})
    $httpBackend.flush()
  ))

  it 'sets "general" as current tab by default', ->
    expect(scope.currentTab).toBe 'general'

  it 'submits a form for user update', ->
    scope.submit()
    $httpBackend.expectPUT('/api/users', {user: {name: "Jackie Chan", email: "jackiechan@test.com"}}).respond({})
    $httpBackend.flush()