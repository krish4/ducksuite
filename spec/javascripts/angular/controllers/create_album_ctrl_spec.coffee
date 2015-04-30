describe 'CreateAlbumCtrl', ->
  scope = undefined
  ctrl = undefined
  $httpBackend = undefined
  $compile = undefined

  beforeEach(module('DucksuiteApp'))

  beforeEach(inject( (_$httpBackend_, $rootScope, $controller, _$compile_) ->
    $httpBackend = _$httpBackend_
    $compile = _$compile_
    scope = $rootScope.$new()
    ctrl = $controller('CreateAlbumCtrl', { $scope: scope })
  ))

  it 'creates new album', ->
    scope.album.hashtags = ['new', 'amazing', 'photos']
    $compile('<form name="createNewAlbumForm"></form>')(scope)
    event = {preventDefault: jasmine.createSpy()}
    scope.createAlbum(event, "createNewAlbumForm")
    $httpBackend.expectPOST('/users/sign_in.json', {"user": {}}).respond({})
    $httpBackend.flush()
    $httpBackend.expectPOST('/api/albums', { album: {id: 1, title: "New album", hashtags: ['new', 'photos']}}).respond(201, {id: 1, title: "New album"})
