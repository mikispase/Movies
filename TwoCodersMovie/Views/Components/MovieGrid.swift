//
//  MovieGrid.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 11/05/2026.
//

import SwiftUI

struct MovieGrid<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    private var columns: [GridItem] {
        let size: CGFloat = UIDevice.isTV ? 475 : 175
        return [GridItem(.adaptive(minimum: size, maximum: size),
                         spacing: UIDevice.isTV ? 60 : 10,
                         alignment: .leading)]
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            content()
        }
    }
}
