//
//  MoviewDetailRatingView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 09/05/2026.
//

import SwiftUI

struct MoviewDetailRatingView : View {
    let voteAvetage:Double?
    let voteCount:Int?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", voteAvetage ?? 0))
                    .fontWeight(.bold)
                Text("/ 10")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.blue)
                Text("\(voteCount ?? 0)")
                    .fontWeight(.medium)
                Text("votes")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top)
    }
    
}
