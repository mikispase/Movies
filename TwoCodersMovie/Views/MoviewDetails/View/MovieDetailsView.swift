//
//  MovieDetailsView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI

struct MovieDetailsView: View {
    @StateObject var viewModel: MovieDetailsViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var favoriteRouter: FavoriteRouter
    @EnvironmentObject var searchRouter: SearchRouter
    @Namespace private var namespace
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if case .error(let error) = viewModel.phaseFetch {
                    ContentUnavailableView(
                        "No Internet Connection",
                        systemImage: "wifi.slash",
                        description:  Text(error.localizedDescription)
                    )
                } else {
                    ScrollView {
                        MovieDetailsHeaderView(model: viewModel.movie, geo: geo, nameSpace: namespace) { mediaFullScreen in
                            viewModel.mediaFullScreen = mediaFullScreen
                        }
                        .ignoresSafeArea(.all)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            if let overview =  viewModel.movie.overview, !overview.isEmpty {
                                MovieDetailsOverviewView(overView: overview)
                            }
                            
                            if let genre = viewModel.moviewDetails?.genres {
                                MovieDetailsGenreView(gentres: genre)
                            }
                            
                            if let releaseDate =  viewModel.movie.releaseDate {
                                MovieDetailsReleaseDateView(releaseDate: releaseDate)
                            }
                            
                            if let voteCount = viewModel.moviewDetails?.voteCount, let voteAverage = viewModel.moviewDetails?.voteAverage {
                                MovieDetailRatingView(voteAvetage: voteAverage, voteCount: voteCount)
                            }
                            
                            if let countries = viewModel.moviewDetails?.productionCountries {
                                MovieDetailsProductionContriesView(countries: countries)

                            }
                            
                            if let credit = viewModel.credit {
                                MovieDetailCastView(credit: credit)
                            }
                            
                            if let url = URL(string: viewModel.moviewDetails?.homepage ?? ""), let details = viewModel.moviewDetails {
                                MovieDetailsExternalPageView(url: url, model: details, routerType: viewModel.routerType)
                            }
                        }
                        .padding(.leading)
                        .redacted(reason: viewModel.isLoading  ? .placeholder  : [])
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .modifier(NavigationTitleInline())
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    debugPrint("Starting deallocating memory from \(viewModel.self)")
                    switch viewModel.routerType {
                    case .home:
                        router.onBack()
                    case .favorite:
                        favoriteRouter.onBack()
                    case .search:
                        searchRouter.onBack()
                    }
                    viewModel.cancellables.removeAll()
                } label: {
                    BackButtonView()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.checkIsFavorite(setValue: true)
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite ?  "heart.fill" : "heart")
                }
            }
        }
        .navigationTitle(viewModel.moviewDetails?.originalTitle ?? viewModel.movie.title ?? viewModel.movie.originalTitle ?? "")
        .fullScreenCover(item: $viewModel.mediaFullScreen, content: { fullScreenMedia in
#if !os(tvOS)
            ShowImageFullScreen(url: fullScreenMedia.url.absoluteString)
                .modifier(AnimationTransition(id: "fullScreenMedia", namespace: namespace))
            #endif
        })
        .fullScreenCover(item: $viewModel.mediaFullScreen, content: { fullScreenMedia in
#if !os(tvOS)
            ShowImageFullScreen(url: fullScreenMedia.url.absoluteString)
                .modifier(AnimationTransition(id: "fullScreenMediaCast", namespace: namespace))
#endif
        })
    }
}
