//
//  MoviewDetailCastView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 09/05/2026.
//

import SwiftUI

struct MoviewDetailCastView: View {
    let credit:CreditsResponse
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(credit.cast, id: \.id) { item in
                        Button {
                            
                        }label: {
                            VStack {
                                PosterImage(url: item.posterImage, placeholder: "user")
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2)
                                    )
                                
                                Text(item.name)
                                    .foregroundStyle(.custom)
                                    .font(.system(size: 13))
                            }
                            
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
}
