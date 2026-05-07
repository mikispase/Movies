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
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        if let model = viewModel.moviewDetails {
                            ScrollView {
                                MovieDetailsHeaderView(model: model, geo: geo, nameSpace: namespace) { mediaFullScreen in
                                    viewModel.mediaFullScreen = mediaFullScreen
                                }
                                VStack(alignment: .leading, spacing: 0) {
                                    if let overview = model.overview {
                                        MovieDetailsOverviewView(overView: overview)
                                    }
                                    
                                    if let releaseDate = model.releaseDate {
                                        MovieDetailsReleaseDateView(releaseDate: releaseDate)
                                    }
                                    
                                    if let countries = viewModel.moviewDetails?.productionCountries {
                                        MovieDetailsProductionContriesView(countries: countries)
                                    }
                                    
                                    if let url = URL(string: model.homepage ?? "") {
                                        MoviesDetailsExternalPageView(url: url, model: model, routerType: viewModel.routerType)
                                    }
                                }
                                .padding(.leading)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    debugPrint("Starting deallocating memory from \(viewModel.self)")
                    switch viewModel.routerType {
                    case .home:
                        router.onBack()
                    case .favorite:
                        favoriteRouter.onBack()
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
        .navigationTitle(viewModel.moviewDetails?.originalTitle ?? "")
        .fullScreenCover(item: $viewModel.mediaFullScreen, content: { fullScreenMedia in
            ShowImageFullScreen(url: fullScreenMedia.url.absoluteString)
                .modifier(AnimationTransition(id: "fullScreenMedia", namespace: namespace))
        })
        
    }
}
