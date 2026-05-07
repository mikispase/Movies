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
                    let model = viewModel.searching ? viewModel.searchObjects : viewModel.movies
                    ForEach(model, id: \.customId) { movie in
                        Button {
                            let model = MovieDetailsViewModel(movieId: movie.id, routerType: .home)
                            router.append(currentView: ViewsEnum.details.rawValue, value: model)
                            
                        } label: {
                            MovieCard(movie: movie)
                        }
                        .frame(width: 175, height: 270)
                        .overlay(alignment: .topTrailing) {
                            FavoriteHeart(model: movie)
                                .offset(x: -15, y: 15)
                        }
                    }

                    if viewModel.searching {
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
            .navigationTitle("Discover")
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .searchScopes($viewModel.searchScope, activation: .onSearchPresentation) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
    }
}

#Preview {
    MoviesView()
}
