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
            PosterImage(url: movie.posterImage, addBlur: true)
                .frame(width: 175, height: 160)
                .overlay(content: {
                    PosterImage(url: movie.posterImage, fit: true)
                        .frame(width: 175, height: 160)
                })

            VStack(alignment: .leading, spacing: 0) {
                Text(movie.title ?? "")
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .semibold))

                Text(movie.overview?.truncated(toLength: 100) ?? "")
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
            }
            Spacer()
        }
    }
}
