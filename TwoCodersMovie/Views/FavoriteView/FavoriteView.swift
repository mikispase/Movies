//
//  FavoriteView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI
import SwiftData

struct FavoriteView:View {
    @EnvironmentObject var favoriteRouter:FavoriteRouter
    
    @Query(filter: #Predicate<Movie> { $0.myFavorite}, sort: \Movie.title, order: .reverse) var favouriteMoviee: [Movie]
    
    var body: some View {
        NavigationStack(path: $favoriteRouter.path) {
            VStack {
                if favouriteMoviee.isEmpty {
                    ContentUnavailableView(
                        "You Have not Favorite",
                        systemImage: "heart.fill",
                        description:  Text("Use the heart icon on the movie card or the details page to save it to your favorites.")
                    )
                } else {
                    ScrollView {
                        MovieGrid {
                            ForEach(favouriteMoviee, id: \.customId) { movie in
                                Button {
                                    let model = MovieDetailsViewModel(movie: movie, fromSeries: false, routerType: .favorite)
                                    favoriteRouter.append(currentView: ViewsEnum.details.rawValue, value: model)
                                    
                                } label: {
                                    MovieCard(movie: movie)
                                }
                                .frame(width: UIDevice.isTV ? 475 : 175, height:  UIDevice.isTV ? 530 :  300)
                                .if(UIDevice.isVision) { view in
                                    view.buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .modifier(NavigationModifier())
            .navigationTitle("Favorite")
           // .toolbar((favoriteRouter.currentView != "") ? .hidden : .visible, for: .tabBar)
        }
    }
}
