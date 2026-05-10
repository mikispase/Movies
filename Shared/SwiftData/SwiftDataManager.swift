//
//  SwiftDataManager.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//
import SwiftData
import SwiftUI
import Combine

class SwiftDataManager : ObservableObject {
    static let shared = SwiftDataManager()
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    private let dbActor: DBActor
    
    private init() {
        do {
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for:Movie.self,
                                                DetailsObject.self,
                                                CreditsObject.self,
                                                configurations: configuration)
            modelContext = ModelContext(modelContainer)
            modelContext.autosaveEnabled = false
            dbActor = DBActor(modelContainer: modelContainer)
            debugPrint(modelContext.sqliteCommand)
        } catch let error {
            debugPrint("help \(error.localizedDescription)")
            fatalError("cannot set up modelContainer: \(error.localizedDescription)")
        }
    }
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

@ModelActor
actor DBActor {
    func getAllMovies() -> [Movie] {
        let descriptor = FetchDescriptor<Movie>(
            sortBy: [SortDescriptor(\.id, order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("*** cannot fetch movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func getMovieById(customId:String) -> Movie? {
        var descriptor = FetchDescriptor<Movie>(
            predicate: #Predicate { $0.customId == customId }
        )
        descriptor.fetchLimit = 1
        do {
            let items = try modelContext.fetch(descriptor)
            return items.first
        } catch {
            print("*** cannot fetch movies by \(customId): \(error.localizedDescription)")
            return nil
        }
    }
    
    func upsertMovies(_ incoming: [Movie]) throws {
        for item in incoming {
            let descriptor = FetchDescriptor<Movie>(
                predicate: #Predicate { $0.id == item.id }
            )
            if let existing = try modelContext.fetch(descriptor).first {
                existing.customId = item.customId
                existing.title = item.title
                existing.originalTitle = item.originalTitle
                existing.overview = item.overview
                existing.releaseDate = item.releaseDate
                existing.posterPath = item.posterPath
                existing.backdropPath = item.backdropPath
                existing.originalLanguage = item.originalLanguage
                existing.popularity = item.popularity
                existing.voteAverage = item.voteAverage
                existing.voteCount = item.voteCount
                existing.isAdult = item.isAdult
                existing.hasVideo = item.hasVideo
                existing.isSoftcore = item.isSoftcore
                existing.genreIds = item.genreIds
            } else {
                modelContext.insert(item)
            }
        }
        try modelContext.save()
    }
    
    func saveFavorite(_ incoming: Movie) throws {
        let descriptor = FetchDescriptor<Movie>(
            predicate: #Predicate { $0.id == incoming.id }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.myFavorite = incoming.myFavorite
        }
        try modelContext.save()
    }
    
    func getMovie(id: Int) -> Movie? {
        let predicate = #Predicate<Movie> { $0.id == id }
        var descriptor = FetchDescriptor<Movie>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("*** cannot fetch movie by id: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllDetails() -> [DetailsObject] {
        let descriptor = FetchDescriptor<DetailsObject>(
            sortBy: [SortDescriptor(\.id, order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("*** cannot fetch details object: \(error.localizedDescription)")
            return []
        }
    }
    
    func getDetails(id: Int) -> DetailsObject? {
        let predicate = #Predicate<DetailsObject> { $0.id == id }
        var descriptor = FetchDescriptor<DetailsObject>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("*** cannot fetch movie details by id: \(error.localizedDescription)")
            return nil
        }
    }
    
    func upsertDetailsObject(_ incoming: DetailsObject) throws {
        let descriptor = FetchDescriptor<DetailsObject>(
            predicate: #Predicate { $0.id == incoming.id }
        )
        
        let existing = try modelContext.fetch(descriptor).first
        
        if let existing = existing {
            // Update existing object
            existing.homepage = incoming.homepage
            existing.voteCount = incoming.voteCount
            existing.overview = incoming.overview
            existing.backdropPath = incoming.backdropPath
            existing.productionCountries = incoming.productionCountries
            existing.voteAverage = incoming.voteAverage
            existing.posterPath = incoming.posterPath
            existing.popularity = incoming.popularity
            existing.budget = incoming.budget
            existing.originCountry = incoming.originCountry
            existing.belongsToCollection = incoming.belongsToCollection
            existing.adult = incoming.adult
            existing.tagline = incoming.tagline
            existing.spokenLanguages = incoming.spokenLanguages
            existing.productionCompanies = incoming.productionCompanies
            existing.softcore = incoming.softcore
            existing.releaseDate = incoming.releaseDate
            existing.imdbID = incoming.imdbID
            existing.title = incoming.title
            existing.runtime = incoming.runtime
            existing.genres = incoming.genres
            existing.originalTitle = incoming.originalTitle
            existing.video = incoming.video
            existing.revenue = incoming.revenue
            existing.status = incoming.status
        } else {
            // Insert new object
            modelContext.insert(incoming)
        }
        
        try modelContext.save()
    }
    
    func upsertCreditsObject(_ incoming: CreditsObject) throws {
        let descriptor = FetchDescriptor<CreditsObject>(
            predicate: #Predicate { $0.id == incoming.id }
        )
        
        let existing = try modelContext.fetch(descriptor).first
        
        if let existing = existing {
            existing.cast = incoming.cast
            existing.crew = incoming.crew
        } else {
            // Insert new object
            modelContext.insert(incoming)
        }
        
        try modelContext.save()
    }

    func getCreditDetails(id: Int) -> CreditsObject? {
        let predicate = #Predicate<CreditsObject> { $0.id == id }
        var descriptor = FetchDescriptor<CreditsObject>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("*** cannot fetch movie by id: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllCredits() -> [CreditsObject] {
        let descriptor = FetchDescriptor<CreditsObject>(
            sortBy: [SortDescriptor(\.id, order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("*** cannot fetch movies: \(error.localizedDescription)")
            return []
        }
    }
}

extension SwiftDataManager {
    
}
//// Write to Database
extension SwiftDataManager {
    @MainActor
    func saveMovies(_ movies: [Movie]) async {
        guard !movies.isEmpty else { return }
        do {
            try await dbActor.upsertMovies(movies)
        } catch {
            debugPrint(error)
        }
    }
    
    @MainActor
    func getAllMovies() async -> [Movie] {
        await dbActor.getAllMovies()
    }
    
    @MainActor
    func getMovieById(custumId: String) async -> Movie? {
        await dbActor.getMovieById(customId: custumId)
    }
    
    @MainActor
    func getMovieById(id: Int) async -> Movie? {
        await dbActor.getMovie(id: id)
    }
    
    @MainActor
    func saveFavorite(movie: Movie) async {
        do {
           try await dbActor.saveFavorite(movie)
        } catch {
            debugPrint(error)
        }
    }
    
    @MainActor
    func getAllDetails() async -> [DetailsObject] {
        await dbActor.getAllDetails()
    }
    
    @MainActor
    func saveDetailsObject(detaisObject: DetailsObject) async {
        do {
           try await dbActor.upsertDetailsObject(detaisObject)
        } catch {
            debugPrint(error)
        }
    }
    
    @MainActor
    func getDetailsById(id: Int) async -> DetailsObject? {
        await dbActor.getDetails(id: id)
    }
    
    @MainActor
    func saveCreditsObject(detaisObject: CreditsObject) async {
        do {
           try await dbActor.upsertCreditsObject(detaisObject)
        } catch {
            debugPrint(error)
        }
    }
    
    @MainActor
    func getCreditDetailsById(id: Int) async -> CreditsObject? {
        await dbActor.getCreditDetails(id: id)
    }
    
    @MainActor
    func getAllCredits() async -> [CreditsObject] {
        await dbActor.getAllCredits()
    }
}
