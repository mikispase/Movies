//
//  MovieDetailsOverviewView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MovieDetailsOverviewView: View {
    let overView: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Overview")
                .font(.headline)
            Text(overView)
                .font(.system(size: 15))
                .padding(.trailing, 8)
        }
        .padding(.top, 16)
#if os(tvOS)
        .focusable()
#endif
    }
}
