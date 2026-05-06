//
//  MovieDetailsView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI

struct MovieDetailsView : View {
    @StateObject var viewModel:MovieDetailsViewModel
    @EnvironmentObject var router: Router
    @Namespace private var namespace
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                }else {
                    if let model = viewModel.moviewDetails {
                        ScrollView {
                            VStack(alignment: .leading) {
                                if let url = model.posterImage {
                                    VStack{
                                        PosterImage(url:url, addBlur: true)
                                            .frame(height:geo.size.height / 2)
                                            .overlay(content: {
                                                PosterImage(url:url, fit: true)
                                                    .frame(height:geo.size.height / 2)
                                                    .modifier(MatchedTransitionSource(id:  "fullScreenMedia", namespace: namespace))
                                                
                                            })
                                    }.onTapGesture {
                                        viewModel.mediaFullScreen = FullScreenMedia(url: url)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    if let overview = model.overview {
                                        MovieDetailsOverviewView(overView: overview)
                                    }
                                    
                                    if let  releaseDate = model.releaseDate {
                                        MovieDetailsReleaseDateView(releaseDate: releaseDate)
                                    }
                                    
                                    if let countries = viewModel.moviewDetails?.productionCountries{
                                        MoviewDetailsProductionContriesView(countries: countries)
                                    }
                                    
                                    Button{
                                        if let url = URL(string: model.homepage ?? "") {
                                            let urlObject = Web(url: url)
                                            router.append(currentView: ViewsEnum.web.rawValue, value: urlObject)
                                        }
                                    }label: {
                                        FlowHStack(horizontalSpacing: 3, verticalSpacing: 0) {
                                            Text("If you want se see more about")
                                                .foregroundStyle(.custom)
                                            Text("\(model.originalTitle ?? "")")
                                                .foregroundStyle(.custom)
                                            Text("Visit original page")
                                                .underline()
                                                .foregroundStyle(.custom)
                                        }
                                    }
                                    .padding(.top)
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
}
