//
//  MovieCard.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI

struct MovieCard: View {
    let movie: Movie
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                PosterImage(url: movie.posterImage, addBlur: true)
                    .frame(width: UIDevice.isTV ? 400 : 175, height: UIDevice.isTV ? 300 : 160)
                    .overlay(content: {
                        PosterImage(url: movie.posterImage, fit: true)
                            .frame(width: UIDevice.isTV ? 400 : 175, height: UIDevice.isTV ? 300 : 160)
                    })
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(movie.title ?? "")
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: UIDevice.isTV ? 27 : 17, weight: .bold))
                    
                    Text(movie.overview?.truncated(toLength: 130) ?? "")
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: UIDevice.isTV ? 24 : 15))
                }
                .padding(.horizontal, 8)
                Spacer()
            }
        }
        .background {
            if colorScheme == .dark {
                Color.gray.opacity(0.2)
            } else {
                Color.black.opacity(0.1)
            }
        }
        
        .overlay(alignment: .topTrailing) {
            FavoriteHeart(model: movie)
                .offset(x: -15, y: 15)
#if os(tvOS)
    .focusable()
#endif
        }
    }
}
