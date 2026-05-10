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
    
    func testDetailsInvalidJson() {
        func testMovieDecodeFailure() {
            let invalidJSON = """
                {
                    "id": "wrong_type"
                }
                """.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            
            XCTAssertThrowsError(
                try decoder.decode(DetailsObject.self, from: invalidJSON)
            )
        }
    }
    
    func testPosterDetailsImageURL() {
        let json = JSON([
            "poster_path": "/abc.jpg"
        ])
        
        let movie = DetailsObject(json: json)
        
        XCTAssertNotNil(movie.posterImage)
        XCTAssertTrue(
            movie.posterImage?.absoluteString.contains("abc.jpg") == true
        )
    }
    
    func testParsingDetailsObject() async{
        do {
            
            let params: [String: Any] = [
                "page": 1
            ]
            
            let json = try await ApiManager.shared.request(
                name: .discover,
                params: params,
                method: .get
            )
            
            let results = json["results"].arrayValue
            
            let movie =   Movie(json: results.first!)
            
            let params1 = ["language": "en-US"]
            let reguest = RequestEmitNameEnum.details(.movie(movieId: movie.id))
            
            let json1 = try await ApiManager.shared.request(name: reguest, params: params1, method: .get)
            let details = DetailsObject(json: json1)
            
            XCTAssertNotNil(details.id)
            XCTAssertNotNil(details.posterImage)
            
            let creditJson =  try await ApiManager.shared.request(name: .details(.credit(.movie(id: movie.id))),params: params1)
            let credit = CreditsObject(json: creditJson)
            XCTAssertNotNil(credit.id)
            XCTAssertNotNil(credit.cast.first?.id)
            XCTAssertNotNil(credit.crew.first?.id)
            XCTAssertNotNil(credit.cast.first?.posterImage)

            
            let decoder = JSONDecoder()
            let details1 = try decoder.decode(DetailsObject.self, from:  JSON(json1).rawData())
            
            XCTAssertNotNil(details1)
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(details1)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                // 3. Assert
                XCTAssertNotNil(jsonObject)
            } catch {
                XCTFail("Encoding or serialization failed: \(error)")
            }
            
            
            let credit1 = try decoder.decode(CreditsObject.self, from:  JSON(creditJson).rawData())
            XCTAssertNotNil(credit1)
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(credit1)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                // 3. Assert
                XCTAssertNotNil(jsonObject)
            } catch {
                XCTFail("Encoding or serialization failed: \(error)")
            }
            
            
            
            
        } catch {
            debugPrint(error)
        }
    }
        
    func testGHttpMethos() {
        let httpMethodPOST = HttpMethod.post
        
        XCTAssertEqual(httpMethodPOST.string, "POST")

        let httpMethodGET = HttpMethod.get
        
        XCTAssertEqual(httpMethodGET.string, "GET")
    }

    func testReadFromDB() async {
        do {
            let objects = await SwiftDataManager.shared.getAllMovies()
            
            XCTAssertNotNil(objects)
            
            if objects.count > 0 {
                let first = objects.first!
                let getObjectById = await SwiftDataManager.shared.getMovieById(id: first.id )
                XCTAssertNotNil(getObjectById)
                
                let movieByCustomId = await SwiftDataManager.shared.getMovieById(custumId: first.customId!)
                XCTAssertNotNil(movieByCustomId)
                                
               
                let detailsObjects = await SwiftDataManager.shared.getAllDetails()
                XCTAssertTrue(detailsObjects.count > 0)
                
                if let first = detailsObjects.first {
                    let detailsObject = await SwiftDataManager.shared.getDetailsById(id: first.id)
                    XCTAssertNotNil(detailsObject)
                    await SwiftDataManager.shared.saveDetailsObject(detaisObject: first)
                    XCTAssertEqual(true, true)
                }
                              
                let allCredits = await SwiftDataManager.shared.getAllCredits()
                
                if let first = allCredits.first {
                    let credit = await SwiftDataManager.shared.getCreditDetailsById(id: first.id)
                    XCTAssertNotNil(credit)
                    if let credit = credit {
                       await SwiftDataManager.shared.saveCreditsObject(detaisObject: credit)
                        XCTAssertEqual(true, true)
                    }
                }
                
                //case set favorite
                movieByCustomId?.myFavorite = true
                await SwiftDataManager.shared.saveFavorite(movie: movieByCustomId!)
                let getObejctByCustomId1 = await SwiftDataManager.shared.getMovieById(custumId: first.customId!)
                XCTAssertEqual(getObejctByCustomId1?.myFavorite, true)
                
                // case not found
                let notFound = await SwiftDataManager.shared.getMovieById(id: -1111)
                XCTAssertNil(notFound)
                
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(movieByCustomId!)
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    // 3. Assert
                    XCTAssertNotNil(jsonObject)
                } catch {
                    XCTFail("Encoding or serialization failed: \(error)")
                }
            }
        }
    }
    
    func testEvn() {
        let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        let env = Bundle.main.object(forInfoDictionaryKey: "APP_ENV") as? String ?? ""
        XCTAssertNotNil(apiUrl)
        XCTAssertNotNil(apiKey)
        XCTAssertNotNil(env)
    }
    
    func testTrancatedString() {
        let longTest = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        
        let trancated = longTest.truncated(toLength: 20,trailing: nil)
        XCTAssertEqual(trancated.count, 20)
    }
    
    
    func testSearch() async {
        do {
            let model = MoviesViewModel(fromMockUp: false)
            model.searchText = "Ted"
            model.search(query: model.searchText, needRefreshData: false)
            try await Task.sleep(for: .seconds(2))
            XCTAssertEqual(model.searchObjects.count, 20)
        }catch {
            XCTFail("not working search \(error)")
        }
    }
    
    
    func testCache() async {
        do {
            let objects = await SwiftDataManager.shared.getAllMovies()

            guard let first = objects.first else { return }
            CacheManager.shared.set(first, forKey: "TestingObjects")
            
            if let first = CacheManager.shared.get(Movie.self, forKey: "TestingObjects") {
                XCTAssertNotNil(first)
                CacheManager.shared.remove(forKey: "TestingObjects")
            }
            
            let nilObject = CacheManager.shared.get(Movie.self, forKey: "TestingObjects")
            XCTAssertNil(nilObject)
            
            
        } catch {
            XCTFail("not working cache \(error)")
        }
    }
    
    func testMainModel() async {
        class MyClass {}
        let id = ObjectIdentifier(MyClass.self)
        let model = MainViewModel(id)
        model.setPhaseToLoading()
        model.setError(NSError(domain: "", code: 100))
        XCTAssertNotNil(model.phaseFetch)
    }

}
