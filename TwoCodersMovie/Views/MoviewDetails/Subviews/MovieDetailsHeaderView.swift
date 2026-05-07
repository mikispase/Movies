//
//  MovieDetailsHeaderView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MovieDetailsHeaderView: View {
    let model:MovieDetails
    let geo:GeometryProxy
    let nameSpace:Namespace.ID
    var action: ((FullScreenMedia) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let url = model.posterImage {
                VStack {
                    PosterImage(url: url, addBlur: true)
                        .frame(height: geo.size.height / 2)
                        .overlay(content: {
                            PosterImage(url: url, fit: true)
                                .frame(height: geo.size.height / 2)
                                .modifier(
                                    MatchedTransitionSource(id: "fullScreenMedia",
                                                            namespace: nameSpace)
                                )
                        })
                }.onTapGesture {
                    action?(FullScreenMedia(url: url))
                }
            }
        }
    }
}
