//
//  MovieDetailsReleaseDateView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MovieDetailsReleaseDateView: View {
    let releaseDate: String

    var body: some View {
        VStack(spacing: 0) {
            Text("Release Date")
                .font(.headline)
                .padding(.top, 16)
            Text(releaseDate)
                .font(.system(size: 15))
        }
#if os(tvOS)
        .focusable()
#endif

    }
}
