//
//  MoviesView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON

struct MoviesView: View {
    @StateObject var viewModel = MoviesViewModel()
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10, alignment: .leading)],
                          alignment: .center, spacing: 10) {
                    ForEach(viewModel.movies, id: \.customId) { movie in
                        Button {
                            let model = MovieDetailsViewModel(movieId: movie.id ?? -1)
                            router.append(currentView: ViewsEnum.details.rawValue, value: model)
                        } label: {
                            MovieCard(movie: movie)
                        }
                        .frame(width: 175, height: 270)
                    }

                    if viewModel.movies.count > 0 && !viewModel.initialLoad && viewModel.shoudLoadMore {
                        ProgressView().onAppear {
                            viewModel.loadMore()
                        }
                    }
                }
            }
            .modifier(NavigationModifier())
            .navigationTitle("Discover")
        }
    }
}

#Preview {
    MoviesView()
}
