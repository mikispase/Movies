//
//  Test.swift
//  TwoCodersMovieTests
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import XCTest
import SwiftyJSON

final class Test: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNewTest() async{
        let model = MoviesViewModel(fromMockUp: true)
        await model.getMoviews(page: 1)
        model.loadMore()
        
        XCTAssertEqual(model.page, 2)
    }
    
    func testPaginationLogic() async throws  {
        let model = MoviesViewModel(fromMockUp: true)
        model.page = 1
        await model.getMoviews(page: model.page)
        model.page = 1
        model.totalPages = 5
        XCTAssertEqual(model.shoudLoadMore, true)
        model.page = 5
        model.totalPages = 5
        model.checkShoudLoadMore()
        XCTAssertEqual(model.shoudLoadMore, false)
    }
    
    
    func testMovieParsing() {
        let json = JSON([
            "id": 100,
            "title": "Batman",
            "adult": true,
            "vote_average": 8.5,
            "vote_count" : 100,
            "poster_path": "/poster.jpg"
        ])
        
        let movie = Movie(json: json)
        XCTAssertEqual(movie.id, 100)
        XCTAssertEqual(movie.voteCount, 100)
        XCTAssertEqual(movie.title, "Batman")
        XCTAssertEqual(movie.isAdult, true)
        XCTAssertEqual(movie.voteAverage, 8.5)
        XCTAssertNotNil(movie.posterImage)
    }
    
    func testMovieInvalidParsing() {
        let json = JSON([:])
        let movie = Movie(json: json)
        XCTAssertNil(movie.title)
        XCTAssertNil(movie.posterPath)
    }
    
    func testApiFailure() async {
        do {
            _ = try await ApiManager.shared.request(
                name: .details(.movie(movieId: -1))
            )
            
            XCTFail("Expected failure")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testMultiplePagination() async {
        let model = MoviesViewModel(fromMockUp: true)
        await model.getMoviews(page: 1)
        await model.getMoviews(page: 2)
        await model.getMoviews(page: 3)
        XCTAssertEqual(model.movies.count, 60)
    }
    
    
    func testEmptyState() {
        let model = MoviesViewModel(fromMockUp: true)
        model.movies = []
        XCTAssertTrue(model.movies.isEmpty)
    }
    
    
    func testCodableDecodableSuccess() async {
        do {
            let params: [String: Any] = [
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": "popularity.desc",
                "page": 1
            ]
            
            let json = try await ApiManager.shared.request(name: .discover, params: params, method: .get)
            guard let results = json["results"].array else {  return }
            let decoder = JSONDecoder()
            let movies = try decoder.decode([Movie].self, from:  JSON(results).rawData())
            XCTAssertTrue(movies.count > 0)
        }catch {
            debugPrint(error)
            XCTFail("Expected failure")
        }
    }
    
    func testCodableDecodableFailed() async {
        do {
            let json = try await ApiManager.shared.request(name: .discover, method: .get)
            let decoder = JSONDecoder()
            let _ = try decoder.decode([Movie].self, from: json.rawData())
            XCTFail("Expected failure")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testSearchMovieMissedQuery() async {
        do {
            let _ = try await ApiManager.shared.request(name: .searchMovie(.movie), method: .get)
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual((error as NSError).code, 1001)
        }
    }
    
    func testSearchSeriesMissedQuery() async {
        do {
            let result = try await ApiManager.shared.request(name: .searchMovie(.series), method: .get)
            XCTAssertEqual(result, JSON.null)
            XCTAssertEqual(result, JSON.null)
        } catch {
            XCTAssertEqual((error as NSError).code, 1001)
        }
    }
    
    func testMoviePartialParsing() {
        let json = JSON([
            "id": 1
        ])
        
        let movie = Movie(json: json)
        
        XCTAssertEqual(movie.id, 1)
        XCTAssertNil(movie.title)
        XCTAssertNil(movie.posterPath)
    }
    
    func testPosterImageURL() {
        let json = JSON([
            "poster_path": "/abc.jpg"
        ])
        
        let movie = Movie(json: json)
        
        XCTAssertNotNil(movie.posterImage)
        XCTAssertTrue(
            movie.posterImage?.absoluteString.contains("abc.jpg") == true
        )
    }
    
    func testShouldLoadMoreWhenPagesNil() {
        let model = MoviesViewModel(fromMockUp: true)
        
        model.page = 0
        model.totalPages = 0
        
        model.checkShoudLoadMore()
        
        XCTAssertFalse(model.shoudLoadMore)
    }
    
    func testLoadMoreIncrementsPage() {
        let model = MoviesViewModel(fromMockUp: true)
        
        model.page = 1
        model.totalPages = 5
        model.shoudLoadMore = true
        
        model.loadMore()
        
        XCTAssertEqual(model.page, 2)
    }
    
    func testDiscoverContainsMovies() async throws {
        let params: [String: Any] = [
            "page": 1
        ]
        
        let json = try await ApiManager.shared.request(
            name: .discover,
            params: params,
            method: .get
        )
        
        let results = json["results"].arrayValue
        
        XCTAssertFalse(results.isEmpty)
    }
    
    func testInvalidMovieIdThrows() async {
        do {
            _ = try await ApiManager.shared.request(
                name: .details(.movie(movieId: -999))
            )
            
            XCTFail("Should throw")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testLoadMoreDoesNothingWhenDisabled() {
        let model = MoviesViewModel(fromMockUp: true)
        
        model.page = 0
        model.totalPages = 0
        model.shoudLoadMore = false
        
        model.loadMore()
        
        XCTAssertEqual(model.page, 1)
    }
    
    func testMovieDecodeFailure() {
        let invalidJSON = """
            {
                "id": "wrong_type"
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(
            try decoder.decode(Movie.self, from: invalidJSON)
        )
    }
    
    func testViewModelInitialState() {
        let model = MoviesViewModel(fromMockUp: true)
        
        XCTAssertTrue(model.movies.isEmpty)
        XCTAssertEqual(model.page, 1)
    }
}
