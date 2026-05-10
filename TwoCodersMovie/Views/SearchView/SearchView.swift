//
//  SearchView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 10/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON


class SearchViewModel: MainViewModel {
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

                SDImagePreloader.shared.preload(urls: moviesList.compactMap({ $0.posterImage }))
                SDImagePreloader.shared.preload(urls: moviesList.compactMap({ $0.poster780Image }))

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

struct SearchView:View {
    @StateObject var viewModel:SearchViewModel = SearchViewModel()
    @EnvironmentObject var searchRouter: SearchRouter
    
    var body: some View {
        NavigationStack(path: $searchRouter.path) {
            ScrollView {
                if viewModel.searchText == "" {
                    ContentUnavailableView(
                        "Search content",
                        systemImage: "magnifyingglass",
                        description: Text("You can search movies and series")
                        )
                } else if viewModel.searching && viewModel.searchObjects.count == 0 && !viewModel.finishSearch {
                    ProgressView()
                        .padding(.top, 30)
                } else if viewModel.searchObjects.count == 0 && viewModel.finishSearch {
                    ContentUnavailableView(
                        "No content found",
                        systemImage: "minus.magnifyingglass",
                        description: Text("Noting found with your criteria")
                        )
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10, alignment: .leading)],
                              alignment: .center, spacing: 10) {
                        ForEach(viewModel.searchObjects, id: \.customId) { movie in
                            Button {
                                let isSeries = viewModel.searchScope == .series && viewModel.searching ? true : false
                                let model = MovieDetailsViewModel(movie: movie, fromSeries: isSeries, routerType: .search)
                                searchRouter.append(currentView: ViewsEnum.details.rawValue, value: model)
                            } label: {
                                MovieCard(movie: movie)
                            }
                            .frame(width: 175, height: 300)
                        }
                        
                        if viewModel.searching {
                            if viewModel.searchObjects.count > 0  && viewModel.shoudLoadMoreSearch {
                                ProgressView().onAppear {
                                    viewModel.loadMore()
                                }
                            }
                        }
                    }
                }
            }
            .modifier(NavigationModifier())
            .navigationTitle("Search")
            //.toolbar((searchRouter.currentView != "") ? .hidden : .visible, for: .tabBar)
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .searchScopes($viewModel.searchScope, activation: .onSearchPresentation) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
    }
}
