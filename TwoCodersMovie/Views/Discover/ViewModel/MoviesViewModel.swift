//
//  MoviesViewModel.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON

enum SearchScope: String, CaseIterable {
    case movies, series
}

class MoviesViewModel: MainViewModel {
    var page = 1
    var totalPages = 0
    
    var pageSearch = 1
    var totalPagesSearch = 0

    @Published var movies: [Movie] = []
    @Published var searchObjects: [Movie] = []
    @Published var initialLoad: Bool = true
    @Published var shoudLoadMore: Bool = true
    @Published var shoudLoadMoreSearch: Bool = true
    @Published var searchText = ""
    @Published var searchScope = SearchScope.movies
    @Published var searching: Bool = false

    init(fromMockUp:Bool = false) {
        super.init(ObjectIdentifier(Self.Type.self))

        if !fromMockUp {
            Task {
                await getMoviews(page: page)
            }
        }
        
        setupSearch()
    }

    @MainActor
    func getMoviews(page: Int) async {
        do {
            let params: [String: Any] = [
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": "popularity.desc",
                "page": page
            ]

            let json =  try await api.request(name: .discover, params: params, method: .get)
            if totalPages == 0 {
                totalPages = json["total_pages"].intValue
            }
            guard let results = json["results"].array else {  return }

            var moviesList: [Movie] = []
            for item in results {
                let movie = Movie(json: item)
                moviesList.append(movie)
            }
            self.movies.append(contentsOf: moviesList)
            self.phaseFetch = .success(self.movies)

            SDImagePreloader.shared.preload(urls: moviesList.compactMap({ $0.posterImage }))

            if initialLoad {
                initialLoad = false
            }

            if page >= totalPages {
                shoudLoadMore = false
            }
            
            checkShoudLoadMore()
            
        } catch {
            setError(error)
            debugPrint(error)
        }
    }

    func loadMore() {
        if searching {
            pageSearch+=1
            
            search(query: searchText)
        } else {
            page+=1
            
            Task { @MainActor in
                await getMoviews(page: page)
            }
        }
    }
    
    func checkShoudLoadMore() {
        if searching {
            if pageSearch >= totalPagesSearch {
                shoudLoadMoreSearch = false
            }
        } else {
            if page >= totalPages {
                shoudLoadMore = false
            }
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
                    return
                }
                
                debugPrint("change: \(updatedQuery)")
                searching = updatedQuery.count > 0
                searchObjects = []
                pageSearch = 1
                totalPagesSearch = 0
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
                    search(query: self.searchText, needRefreshData: true)
                }
            })
            .store(in: &cancellables)
        
    }
    
    private func search(query: String, needRefreshData:Bool = false) {
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
                    moviesList.append(movie)
                }
                withAnimation {
                    self.searchObjects.append(contentsOf: moviesList)
                }
                
                self.phaseFetch = .success(self.searchObjects)

                SDImagePreloader.shared.preload(urls: moviesList.compactMap({ $0.posterImage }))

                if pageSearch >= totalPagesSearch {
                    shoudLoadMoreSearch = false
                }
                
                checkShoudLoadMore()
                
            } catch {
                setError(error)
                self.isLoading = false
            }
        }
    }
}
