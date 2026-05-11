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
    let routerType:RouterType

    @Published var moviewDetails: DetailsObject?
    @Published var mediaFullScreen: FullScreenMedia?
    @Published var mediaFullScreenCast: FullScreenMedia?
    @Published var credit: CreditsObject?
    @Published var isFavorite: Bool = false
        
    init(movie: Movie, fromSeries: Bool, fromMockUp:Bool = false, routerType:RouterType) {
        self.movie = movie
        self.fromSeries = fromSeries
        self.routerType = routerType
        
        super.init(ObjectIdentifier(Self.Type.self))
        
        if !fromMockUp {
            Task { @MainActor in
                
                if let detailsObject = await SwiftDataManager.shared.getDetailsById(id: movie.id) {
                    self.moviewDetails = detailsObject
                    
                    if let creditDetials = await SwiftDataManager.shared.getCreditDetailsById(id: movie.id) {
                        self.credit = creditDetials
                    }
                    self.phaseFetch = .success(detailsObject)
                }
                
                await self.getDetails()
                
                await withTaskGroup(of: Void.self) { group in
//                    group.addTask(priority: .userInitiated) {  [weak self] in
//                        await self?.getDetails()
//                    }
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
            var request = movie.hasVideo ?? true ? RequestEmitNameEnum.details(.series(series: movie.id)) : RequestEmitNameEnum.details(.movie(movieId: movie.id))
            
            // need to double check
            if movie.mediaType == "movie" {
                request = RequestEmitNameEnum.details(.movie(movieId: movie.id))
            }
            // need to double check
            if fromSeries {
                request = RequestEmitNameEnum.details(.series(series: movie.id))
            }
            
            let json = try await api.request(name: request, params: params, method: .get)
            moviewDetails = DetailsObject(json: json)
            
            let requestCredit = movie.hasVideo ?? true ? RequestEmitNameEnum.details(.credit(.series(id: movie.id))) : RequestEmitNameEnum.details(.credit(.movie(id: movie.id)))
            if let creditJson = try? await api.request(name: requestCredit, params: params, method: .get) {
                let creditResponce = CreditsObject(json: creditJson)
                self.credit = creditResponce
            
                await SwiftDataManager.shared.saveCreditsObject(detaisObject: creditResponce)
            }
            
            if let moviewDetails = moviewDetails {
                await SwiftDataManager.shared.saveDetailsObject(detaisObject: moviewDetails)
            }
            
            if let obj = moviewDetails {
                phaseFetch = .success(obj)
            }
        } catch {
            setError(error)
            debugPrint(error)
            
            if let detailsObject = await SwiftDataManager.shared.getDetailsById(id: movie.id) {
                self.moviewDetails = detailsObject
                
                if let creditDetials = await SwiftDataManager.shared.getCreditDetailsById(id: movie.id) {
                    self.credit = creditDetials
                }
                self.phaseFetch = .success(detailsObject)
            }
        }
    }
    
    @MainActor
    func checkIsFavorite(setValue:Bool = false) async {
        let movieFromDb = await SwiftDataManager.shared.getMovieById(id: movie.id)
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
