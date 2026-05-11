//
//  SearchViewModel.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 11/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON

class SearchViewModel: MainViewModel, ImagePreloadable {
    var pageSearch = 1
    var totalPagesSearch = 0
    
    @Published var searchObjects: [Movie] = []
    @Published var finishSearch: Bool = false
    @Published var shoudLoadMoreSearch: Bool = true
    
    @Published var searchText = ""
    @Published var searchScope = SearchScope.movies
    @Published var searching: Bool = false
    
    init(fromMockUp:Bool = false) {
        super.init(ObjectIdentifier(Self.Type.self))
        
        if !fromMockUp {
            setupSearch()
        }
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main, options: .none)
            .sink(receiveValue: { [weak self] updatedQuery in
                guard let self else { return }
                
                debugPrint("updatedQuery: \(updatedQuery)")
                searchObjects = []
                pageSearch = 1
                totalPagesSearch = 0
                shoudLoadMoreSearch = true
                search(query: updatedQuery, needRefreshData: true)
            })
            .store(in: &cancellables)
        
        $searchText
            .sink(receiveValue: { [weak self] updatedQuery in
                guard let self else { return }
                if updatedQuery.isEmpty {
                    pageSearch = 1
                    shoudLoadMoreSearch = true
                    searchObjects = []
                    totalPagesSearch = 0
                    finishSearch = false
                    return
                }
                
                debugPrint("change: \(updatedQuery)")
                searching = updatedQuery.count > 0
                searchObjects = []
                pageSearch = 1
                totalPagesSearch = 0
                finishSearch = false
                shoudLoadMoreSearch = true
            })
            .store(in: &cancellables)
        
        $searchScope
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main, options: .none)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                if searching {
                    searchObjects = []
                    pageSearch = 1
                    totalPagesSearch = 0
                    shoudLoadMoreSearch = true
                    finishSearch = false
                    search(query: self.searchText, needRefreshData: true)
                }
            })
            .store(in: &cancellables)
        
    }
    
    func search(query: String, needRefreshData:Bool = false) {
        if query.isEmpty {
            searching = false
            return
        }
        
        let params:[String: Any] = [
            "query": query,
            "include_adult": false,
            "language": "en-US",
            "page": pageSearch
        ]
        
        let path = searchScope == .movies ?
        RequestEmitNameEnum.searchMovie(.movie) :
        RequestEmitNameEnum.searchMovie(.series)
        
        Task(priority: .userInitiated) { @MainActor in
            do {
                let json = try await api.request(name: path, params: params, method: .get)
                debugPrint(json)
                
                if needRefreshData {
                    self.searchObjects = []
                }
                
                totalPagesSearch = json["total_pages"].intValue
                
                guard let results = json["results"].array else {  return }
                
                var moviesList: [Movie] = []
                for item in results {
                    let movie = Movie(json: item)
                    
                    if movie.title == nil && movie.posterImage == nil && ( movie.overview == nil || movie.overview == "") {
                        continue
                    }
                    moviesList.append(movie)
                    
                }
                
                self.searchObjects.append(contentsOf: moviesList)
                
                self.phaseFetch = .success(self.searchObjects)
                
                preloadImages(for: moviesList)
                
                if pageSearch >= totalPagesSearch {
                    shoudLoadMoreSearch = false
                }
                
                finishSearch = true
                
                checkShoudLoadMore()
                
            } catch {
                setError(error)
                self.isLoading = false
            }
        }
    }
    
    func checkShoudLoadMore() {
        if searching {
            if pageSearch >= totalPagesSearch {
                shoudLoadMoreSearch = false
            }
        }
    }
    
    func loadMore() {
        if searching {
            pageSearch+=1
            
            search(query: searchText)
        }
    }
}
