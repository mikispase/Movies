//
//  FavoriteHeart.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//
import SwiftUI
import SwiftData

struct FavoriteHeart: View {
    let model:Movie
    
    @Query(filter: #Predicate<Movie> { $0.myFavorite}, sort: \Movie.title, order: .reverse) var favouriteMoviee: [Movie]

    var body: some View {
        Button {
            if let movie = favouriteMoviee.first(where: { $0.id == model.id }) {
                movie.myFavorite = !movie.myFavorite
                Task { @MainActor in
                  await SwiftDataManager.shared.saveFavorite(movie: movie)
                }
            } else {
                Task { @MainActor in
                    if let movie = await SwiftDataManager.shared.getMovieById(id: model.id ) {
                        movie.myFavorite = true
                        await SwiftDataManager.shared.saveFavorite(movie: movie)
                    } else {
                        // case not exit in DB
                        model.myFavorite = !model.myFavorite
                        await SwiftDataManager.shared.saveMovies([model])
                        await SwiftDataManager.shared.saveFavorite(movie: model)
                    }
                }
            }
        }label: {
            if favouriteMoviee.contains(where: { $0.id == model.id && $0.myFavorite }) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.white)
            } else {
                Image(systemName: "heart")
                    .foregroundStyle(.white)
            }
        }
    }
}
