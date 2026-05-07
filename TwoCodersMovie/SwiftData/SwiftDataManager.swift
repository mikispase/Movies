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
    func movie(withID movieID: Int) async -> Movie? {
        await dbActor.getMovie(id: movieID)
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
}
