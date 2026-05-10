//
//  MoviesView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON

struct MoviesView: View {
    @StateObject var viewModel = MoviesViewModel()
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10, alignment: .leading)],
                          alignment: .center, spacing: 10) {
                    
                    let model = (viewModel.searching && embederdSearchInMainView) ? viewModel.searchObjects : viewModel.movies

                    ForEach(model, id: \.customId) { movie in
                        Button {
                            let isSeries = viewModel.searchScope == .series && viewModel.searching ? true : false
                            let model = MovieDetailsViewModel(movie: movie, fromSeries: isSeries, routerType: .home)
                            router.append(currentView: ViewsEnum.details.rawValue, value: model)
                        } label: {
                            MovieCard(movie: movie)
                        }
                        .frame(width: 175, height: 300)
                    }
                    if viewModel.searching && embederdSearchInMainView {
                        if viewModel.searchObjects.count > 0  && viewModel.shoudLoadMoreSearch {
                            ProgressView().onAppear {
                                viewModel.loadMore()
                            }
                        }
                    } else {
                        if viewModel.movies.count > 0 && !viewModel.initialLoad && viewModel.shoudLoadMore {
                            ProgressView().onAppear {
                                viewModel.loadMore()
                            }
                        }
                    }
                }
            }
            .modifier(NavigationModifier())
            .navigationTitle("Trending")
            .toolbar((router.currentView != "") ? .hidden : .visible, for: .tabBar)
        }
        .if(embederdSearchInMainView) { view in
            view.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        }
        .if(embederdSearchInMainView) { view in
            view.searchScopes($viewModel.searchScope, activation: .onSearchPresentation) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue.capitalized)
                }
            }
        }
    }
}

#Preview {
    MoviesView()
}
