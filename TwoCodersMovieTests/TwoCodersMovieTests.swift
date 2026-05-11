//
//  TwoCodersMovieTests.swift
//  TwoCodersMovieTests
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import Testing
import SwiftyJSON
import UIKit
@testable import TwoCodersMovie

 //Note firt time I write Test!!!!!!
struct TwoCodersMovieTests {
    @Test
    func testDiscover() async throws {
        
        let model = TrendingViewModel(fromMockUp: true)
        await model.getMoviews(page: model.page)
        model.page += 1
        await model.getMoviews(page: model.page)
        
        #expect(model.page == 2)
        #expect(model.movies.count == 40)
        #expect(model.initialLoad == false)
        #expect(model.shoudLoadMore ==  (model.page < model.totalPages))
        
        guard let movie = model.movies.first else {
            Issue.record("No movies found")
            return
        }
        guard let _ = movie.customId else {
            Issue.record("Movie ID is nil")
            return
        }
        
        guard let url = movie.posterImage else {
            Issue.record("Url is nil")
            return
        }
        
        #expect(!url.absoluteString.isEmpty)
        
        guard let isAdult = movie.isAdult else {
            Issue.record("isAdult is True")
            return
        }
        #expect(isAdult == false)
    }
    
    @Test("Check formats ID", arguments: ["123", "321", "ID-999"])
    func testMovieIDFormats(id: String) {
        guard let _ = Int(id) else {
            #expect(true)
            return
        }
    }
    
    @Test(.disabled("Wainting fix from backend"))
    func testBrokenFeature() {
        // ...
    }
    
    @Test
    func testPaginationLogic() async throws  {
        let model = TrendingViewModel(fromMockUp: true)
        model.page = 1
        await model.getMoviews(page: model.page)
        model.page = 1
        model.totalPages = 5
        #expect(model.shoudLoadMore == true)
        model.page = 5
        model.totalPages = 5
        model.checkShoudLoadMore()
        #expect(model.shoudLoadMore == false)
    }
    
    @Test
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
        #expect(movie.id == 100)
        #expect(movie.voteCount == 100)
        #expect(movie.title == "Batman")
        #expect(movie.isAdult == true)
        #expect(movie.voteAverage == 8.5)
        #expect(movie.posterImage != nil)
    }
    
    @Test
    func testMovieInvalidParsing() {
        let json = JSON([:])
        let movie = Movie(json: json)
        #expect(movie.title == nil)
        #expect(movie.posterPath == nil)
    }
    
    @Test
    func testApiFailure() async {
        do {
            _ = try await ApiManager.shared.request(name: .details(.movie(movieId: -1)))
            Issue.record("Expected failure")
        } catch {
            #expect(true)
        }
    }
    
    @Test
    func testMultiplePagination() async {
        let model = TrendingViewModel(fromMockUp: true)
        await model.getMoviews(page: 1)
        await model.getMoviews(page: 2)
        await model.getMoviews(page: 3)
        #expect(model.movies.count == 60)
    }
    
    @Test
    func testEmptyState() {
        let model = TrendingViewModel(fromMockUp: true)
        model.movies = []
        #expect(model.movies.isEmpty)
    }
    
    @Test
    func testCodableDecodableSuccess() async {
        do {
            let params: [String: Any] = [
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": "popularity.desc",
                "page": 1
            ]
            
            let json = try await ApiManager.shared.request(name: .trending, params: params, method: .get)
            guard let results = json["results"].array else {  return }
            let decoder = JSONDecoder()
            let movies = try decoder.decode([Movie].self, from:  JSON(results).rawData())
            #expect(movies.count > 0)
        }catch {
            debugPrint(error)
            Issue.record("Expected failure")
        }
    }
    
    @Test
    func testCodableDecodableFailed() async {
        do {
            let json = try await ApiManager.shared.request(name: .trending, method: .get)
            let decoder = JSONDecoder()
            let _ = try decoder.decode([Movie].self, from: json.rawData())
            Issue.record("Expected failure")
        }catch {
            #expect(true)
        }
    }
    
    @Test
    func searchMovieMissedQuery() async {
        do {
            let _ = try await ApiManager.shared.request(name: .searchMovie(.movie), method: .get)
            Issue.record("Expected failure")
        }catch {
            #expect((error as NSError).code == 1001)
        }
    }
    
    @Test
    func searchSeriesMissedQuery() async {
        do {
            let result = try await ApiManager.shared.request(name: .searchMovie(.series), method: .get)
            #expect(result == JSON.null)
            #expect(result == JSON.null)
        }catch {
            #expect((error as NSError).code == 1001)
        }
    }
}
