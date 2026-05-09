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
    let fromSeries: Bool

    @Published var moviewDetails: DetailsObject?
    
    @Published var mediaFullScreen: FullScreenMedia?
    
    @Published var credit: CreditsResponse?

    @Published var isFavorite: Bool = false
    
    let routerType:RouterType
    
    init(movie: Movie, fromSeries: Bool, fromMockUp:Bool = false, routerType:RouterType) {
        self.movie = movie
        self.fromSeries = fromSeries
        self.routerType = routerType
        
        super.init(ObjectIdentifier(Self.Type.self))
        
        if !fromMockUp {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask(priority: .userInitiated) {  [weak self] in
                        await self?.getDetails()
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
    func getDetails() async {
        do {
            let params = ["language": "en-US"]
            let request = movie.hasVideo ?? true ? RequestEmitNameEnum.details(.series(series: movie.id)) : RequestEmitNameEnum.details(.movie(movieId: movie.id))
            
            let json = try await api.request(name: request, params: params, method: .get)
            debugPrint(json)
            moviewDetails = DetailsObject(json: json)
            
            let requestCredit = movie.hasVideo ?? true ? RequestEmitNameEnum.details(.credit(.series(id: movie.id))) : RequestEmitNameEnum.details(.credit(.movie(id: movie.id)))
            let creditJson = try await api.request(name: requestCredit, params: params, method: .get)
            
            let creditResponce = CreditsResponse(json: creditJson)
            self.credit = creditResponce
            
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
