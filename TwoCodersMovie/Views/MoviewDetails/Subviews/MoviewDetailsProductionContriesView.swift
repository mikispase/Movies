//
//  MoviewDetailsProductionContriesView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MoviewDetailsProductionContriesView: View {
    let countries: [ProductionCountry]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if countries.count > 0 {
                Text("Production Contries")
            }
            HStack {
                ForEach(countries, id: \.iso) { country in
                    HStack {
                        Text(country.flagEmoji(for: country.iso ?? ""))
                        Text(country.name ?? "")
                            .font(.caption)
                            .padding(.leading, 3)
                    }
                }
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}
