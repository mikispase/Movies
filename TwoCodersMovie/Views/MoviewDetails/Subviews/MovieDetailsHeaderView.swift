//
//  MovieDetailsHeaderView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MovieDetailsHeaderView: View {
    let model:Movie
    let geo:GeometryProxy
    let nameSpace:Namespace.ID
    var action: ((FullScreenMedia) -> Void)?
    
    var body: some View {
        let isLandscape = geo.size.width > geo.size.height
        let divider = UIDevice.isIpad ? isLandscape ? 1.5 : 2 : isLandscape ? 1.2 : 2
        VStack(alignment: .leading) {
                VStack {
                    PosterImage(url: model.posterImage, addBlur: true)
                        .frame(height: geo.size.height / CGFloat(divider) )
                        .overlay(content: {
                            PosterImage(url: model.posterImage, fit: true)
                                .frame(height: geo.size.height / CGFloat(divider) )
                                .modifier(
                                    MatchedTransitionSource(id: "fullScreenMedia",
                                                            namespace: nameSpace)
                                )
                        })
                        .ignoresSafeArea(.all, edges: .top)
                }.onTapGesture {
                    if let url = model.posterImage {
                        action?(FullScreenMedia(url: url))
                    }
                }
        }
#if os(tvOS)
        .focusable()
#endif
    }
}
