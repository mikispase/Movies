//
//  MovieDetailRatingView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 09/05/2026.
//

import SwiftUI

struct MovieDetailRatingView : View {
    let voteAvetage:Double?
    let voteCount:Int?
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rating / Votes")
                .font(.headline)
            
            HStack(alignment: .top, spacing: 20) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                    Text(String(format: "%.1f", voteAvetage ?? 0))
                        .font(.subheadline)
                    Text("/ 10")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                    Text("\(voteCount ?? 0)")
                        .font(.subheadline)
                    Text("votes")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top)

    }
    
}
