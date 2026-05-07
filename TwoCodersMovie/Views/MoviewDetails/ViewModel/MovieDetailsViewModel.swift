//
//  MovieDetailsViewModel.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
import SwiftUI
import Combine

class MovieDetailsViewModel: MainViewModel {
    let movie: Movie
    
    @Published var moviewDetails: MovieDetails?
    
    @Published var mediaFullScreen: FullScreenMedia?
    
    @Published var isFavorite: Bool = false
    
    let routerType:RouterType
    
    init(movie: Movie, fromMockUp:Bool = false, routerType:RouterType) {
        self.movie = movie
        self.routerType = routerType
        
        super.init(ObjectIdentifier(Self.Type.self))
        
        if !fromMockUp {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask(priority: .userInitiated) {  [weak self] in
                        await self?.getMovieDetails()
                    }
                    group.addTask(priority: .userInitiated) { [weak self] in
                        await self?.checkIsFavorite()
                    }
                }
            }
        }
    }
    
    @MainActor
    deinit {
        debugPrint("deinit MovieDetailsViewModel")
    }
    
    @MainActor
    func getMovieDetails() async {
        do {
            let params = ["language": "en-US"]
            let json = try await api.request(name: .movieDetails(movieId: movie.id), params: params)
            debugPrint(json)
            moviewDetails = MovieDetails(json: json)
            if let obj = moviewDetails {
                phaseFetch = .success(obj)
            }
        } catch {
            setError(error)
            debugPrint(error)
        }
    }
    
    @MainActor
    func checkIsFavorite(setValue:Bool = false) async {
        let movieFromDb = await SwiftDataManager.shared.movie(withID: movie.id)
        if movieFromDb == nil {
            await SwiftDataManager.shared.saveMovies([self.movie])
        }
        
        if !setValue {
            isFavorite = movieFromDb?.myFavorite ?? false
        } else {
            if let movie = movieFromDb {
                movie.myFavorite = !movie.myFavorite
                await SwiftDataManager.shared.saveFavorite(movie: movie)
                isFavorite = movie.myFavorite
            }
        }
    }
}
