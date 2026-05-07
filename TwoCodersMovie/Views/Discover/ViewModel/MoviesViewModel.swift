//
//  MoviesViewModel.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine
import SwiftyJSON

class MoviesViewModel: MainViewModel {
    var page = 1
    var totalPages = 0

    @Published var movies: [Movie] = []
    @Published var initialLoad: Bool = true
    @Published var shoudLoadMore: Bool = true

    init(fromMockUp:Bool = false) {
        super.init(ObjectIdentifier(Self.Type.self))

        if !fromMockUp {
            Task {
                await getMoviews(page: page)
            }
        }
    }

    @MainActor
    func getMoviews(page: Int) async {
        do {
            let params: [String: Any] = [
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": "popularity.desc",
                "page": page
            ]

            let json =  try await api.request(name: .discover, params: params, method: .get)
            if totalPages == 0 {
                totalPages = json["total_pages"].intValue
            }
            guard let results = json["results"].array else {  return }

            var moviesList: [Movie] = []
            for item in results {
                let movie = Movie(json: item)
                moviesList.append(movie)
            }
            self.movies.append(contentsOf: moviesList)
            self.phaseFetch = .success(self.movies)

            SDImagePreloader.shared.preload(urls: moviesList.compactMap({ $0.posterImage }))

            if initialLoad {
                initialLoad = false
            }

            if page >= totalPages {
                shoudLoadMore = false
            }
            
            checkShoudLoadMore()
            
        } catch {
            setError(error)
            debugPrint(error)
        }
    }

    func loadMore() {
        page+=1

        Task { @MainActor in
          await getMoviews(page: page)
        }
    }
    
    func checkShoudLoadMore() {
        if page >= totalPages {
            shoudLoadMore = false
        }
    }
}
