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
    @Namespace private var namespace
    
    var body: some View {
        GeometryReader { geo in
            VStack {
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
                                    MoviewDetailsExternalPageView(url: url, model: model)
                                }
                            }
                            .padding(.leading)
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
                    router.onBack()
                    viewModel.cancellables.removeAll()
                } label: {
                    BackButtonView()
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
