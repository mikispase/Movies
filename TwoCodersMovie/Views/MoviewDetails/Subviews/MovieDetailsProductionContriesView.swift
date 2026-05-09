//
//  MovieDetailsProductionContriesView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MovieDetailsProductionContriesView: View {
    let countries: [ProductionCountry]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if countries.count > 0 {
                Text("Production Contries")
                    .font(.headline)
            }
            HStack {
                ForEach(countries, id: \.iso) { country in
                    HStack {
                        Text(country.flagEmoji(for: country.iso ?? ""))
                        Text(country.name ?? "")
                            .font(.system(size: 15))
                            .padding(.leading, 3)
                    }
                }
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}
