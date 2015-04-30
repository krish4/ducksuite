describe 'AlbumsCtrl', ->
  scope = undefined
  ctrl = undefined
  $httpBackend = undefined

  beforeEach(module('DucksuiteApp'))

  beforeEach(inject( (_$httpBackend_, $rootScope, $controller) ->
    $httpBackend = _$httpBackend_
    $httpBackend.expectGET('/api/albums').respond([
      { id: 1, title: 'Amazing pictures 1', hashtags: ["amazing", "superb"], "is_published": false },
      { id: 2, title: 'Amazing pictures 2', hashtags: ["good"], "is_published": false }
    ])
    scope = $rootScope.$new()
    ctrl = $controller('AlbumsCtrl', { $scope: scope })
  ))

  it 'sets by default an empty collection of albums', ->
    expect(scope.albums).toEqual {}

  it 'fetches an array of albums', ->
    $httpBackend.flush()
    expect(scope.albums.length).toBe 2
    expect(scope.albums[0].title).toEqual 'Amazing pictures 1'
    expect(scope.albums[1].title).toEqual 'Amazing pictures 2'

  it 'selects album by its index', ->
    expect(scope.selectedAlbumIndex).toBeUndefined()
    scope.selectAlbumByIndex(2)
    expect(scope.selectedAlbumIndex).toBe 2

  it 'sets selected album as published', ->
    $httpBackend.flush()
    scope.selectAlbumByIndex 0
    expect(scope.albums[0].is_published).toBe false
    scope.selectAlbumAsPublished()
    $httpBackend.expectPUT('/api/albums/1').respond 204
    $httpBackend.flush()
    expect(scope.albums[0].is_published).toBe true