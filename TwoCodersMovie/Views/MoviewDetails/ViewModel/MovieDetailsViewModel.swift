//
//  MovieDetailsViewModel.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
import SwiftUI
import Combine

class MovieDetailsViewModel: MainViewModel {
    let movieId:Int
    
    @Published var moviewDetails:MovieDetails?

    @Published var mediaFullScreen: FullScreenMedia?

    init(movieId:Int) {
        self.movieId = movieId
        super.init(ObjectIdentifier(Self.Type.self))
        
        Task {
            await getMovieDetails()
        }
    }
    
    @MainActor
    deinit {
        debugPrint("deinit MovieDetailsViewModel")
    }
    
    @MainActor
    func getMovieDetails() async {
        do {
            let params = ["language" : "en-US"]
            let json = try await api.request(name: .movieDetails(movieId: movieId), params: params)
            debugPrint(json)
            moviewDetails = MovieDetails(json: json)
            isLoading = false
            debugPrint(moviewDetails)
            
        }catch {
            debugPrint(error)
        }
    }
    
   
}
