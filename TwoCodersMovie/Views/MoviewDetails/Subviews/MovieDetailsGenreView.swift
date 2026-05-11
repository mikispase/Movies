//
//  MovieDetailsGenreView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 11/05/2026.
//

import SwiftUI

struct MovieDetailsGenreView: View {
    let gentres:[Genre]
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Genre")
                .font(.headline)
            
            FlowHStack {
                ForEach(gentres, id:\.id) { genre in
                    Text(genre.name ?? "")
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.top)
#if os(tvOS)
        .focusable()
#endif
    }
}
