//
//  MoviesView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON





struct MoviesView : View {
    @StateObject var viewModel = MoviesViewModel()
    @StateObject var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10, alignment: .leading)], alignment: .center, spacing: 10) {
                    ForEach(viewModel.movies, id: \.customId) { movie in
                        Button {
                            // TODO: // Details Page
                        } label: {
                            MovieCard(movie: movie)
                        }
                        .frame(width: 175, height:270)
                    }
                    
                    if !viewModel.initialLoad && viewModel.shoudLoadMore{
                        ProgressView().onAppear {
                            viewModel.loadMore()
                        }
                    }
                }
            }
        }
    }
}




#Preview {
    MoviesView()
}

