//
//  MovieDetailsReleaseDateView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//


import SwiftUI

struct MovieDetailsReleaseDateView :View {
    let releaseDate:String
    
    var body: some View {
        Text("Release Date:")
            .padding(.top,16)
        Text(releaseDate)
    }
}