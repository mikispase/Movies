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
            FlowHStack {
                ForEach(countries, id: \.code) { country in
                    HStack(spacing: 0) {
                        Text(country.flagEmoji(for: country.code))
                        Text(country.name)
                            .font(.system(size: 15))
                            .padding(.leading, 3)
                    }
                }
                Spacer()
            }
        }
        .padding(.top, 16)
#if os(tvOS)
        .focusable()
#endif
    }
}
