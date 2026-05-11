//
//  TrendingView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON

struct TrendingView: View {
    @StateObject var viewModel = TrendingViewModel()
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                MovieGrid {
                    let model = (viewModel.searching && embederdSearchInMainView) ? viewModel.searchObjects : viewModel.movies

                    ForEach(model, id: \.customId) { movie in
                        Button {
                            let isSeries = viewModel.searchScope == .series && viewModel.searching ? true : false
                            let model = MovieDetailsViewModel(movie: movie, fromSeries: isSeries, routerType: .home)
                            router.append(currentView: ViewsEnum.details.rawValue, value: model)
                        } label: {
                            MovieCard(movie: movie)
                        }
                        .frame(width: UIDevice.isTV ? 475 : 175, height:  UIDevice.isTV ? 530 :  300)
                        .if(UIDevice.isVision) { view in
                            view.buttonStyle(.plain)
                        }
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
            .navigationTitle("Trending Movies")
           // .toolbar((router.currentView != "") ? .hidden : .visible, for: .tabBar)
            .modifier(NavigationModifier())
        }
        .if(embederdSearchInMainView) { view in
            #if os(tvOS)
            view.searchable(text: $viewModel.searchText)
            #else
            view.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            #endif
        }
        .if(embederdSearchInMainView) { view in
            #if os(tvOS)
            view.searchScopes($viewModel.searchScope) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue.capitalized)
                }
            }
            #else
            view.searchScopes($viewModel.searchScope, activation: .onSearchPresentation) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue.capitalized)
                }
            }
            #endif
        }
    }
}

#Preview {
    TrendingView()
}
