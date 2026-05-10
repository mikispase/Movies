//
//  MoviewDetailCastView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 09/05/2026.
//

import SwiftUI

struct MoviewDetailCastView: View {
    let credit:CreditsObject
    @Namespace private var namespace
    @State var mediaFullScreenCast:FullScreenMedia?
    var body: some View {
        VStack(alignment: .leading) {
            if credit.cast.count > 0 {
                Text("Cast")
                    .font(.headline)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(credit.cast, id: \.id) { item in
                        if let profilePath = item.profilePath, let url = URL(string: "https://image.tmdb.org/t/p/w780\(profilePath)") {
                            Button {
                                mediaFullScreenCast = FullScreenMedia(url: url)
                            } label: {
                                VStack {
                                    PosterImage(url: item.posterImage, placeholder: "user")
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .modifier(
                                            MatchedTransitionSource(id: url.absoluteString,
                                                                   namespace: namespace)
                                        )
                                    
                                    Text(item.name)
                                        .foregroundStyle(.custom)
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.center)
                                        .frame(width: 80)
                                }
                            }
                        }
                    }
                }
            }
            .modifier(ScrollTargetLayout())
            .modifier(ScrollPaging())
        }
        .fullScreenCover(item: $mediaFullScreenCast, content: { fullScreenMedia in
            ShowImageFullScreen(url: fullScreenMedia.url.absoluteString)
                .modifier(AnimationTransition(id: fullScreenMedia.url.absoluteString, namespace: namespace))
        })
    }
}
