//
//  MovieDetailsOverviewView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//


import SwiftUI

struct MovieDetailsOverviewView:View {
    let overView:String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            Text(overView)
                .font(.system(size: 15))
        }
        .padding(.top,16)
    }
}