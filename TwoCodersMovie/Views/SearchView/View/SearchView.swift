//
//  SearchView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 10/05/2026.
//

import SwiftUI

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
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: UIDevice.isTV ? 475 : 175, maximum: UIDevice.isTV ? 475 :  175), spacing:UIDevice.isTV ? 60 : 10, alignment: .leading)],
                              alignment: .center, spacing: 10) {
                        ForEach(viewModel.searchObjects, id: \.customId) { movie in
                            Button {
                                let isSeries = viewModel.searchScope == .series && viewModel.searching ? true : false
                                let model = MovieDetailsViewModel(movie: movie, fromSeries: isSeries, routerType: .search)
                                searchRouter.append(currentView: ViewsEnum.details.rawValue, value: model)
                            } label: {
                                MovieCard(movie: movie)
                            }
                            .frame(width: UIDevice.isTV ? 475 : 175, height:  UIDevice.isTV ? 530 :  300)
                            .if(UIDevice.isVision) { view in
                                view.buttonStyle(.plain)
                            }

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
            // .toolbar((searchRouter.currentView != "") ? .hidden : .visible, for: .tabBar)
        }
#if os(tvOS)
        .searchable(text: $viewModel.searchText, placement: .automatic)
#else
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
#endif
        
#if os(tvOS)
        .searchScopes($viewModel.searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
#else
        .searchScopes($viewModel.searchScope, activation: .onSearchPresentation) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
#endif
    }
}
