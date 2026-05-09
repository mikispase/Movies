//
//  TwoCodersMovieApp.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import SDWebImage
import SwiftData

@main
struct TwoCodersMovieApp: App {
    @StateObject var router = Router()
    @StateObject var favoriteRouter = FavoriteRouter()

    init() {
        SDImageCache.shared.config.maxMemoryCount = 1
        SDImageCache.shared.config.maxDiskSize = 100 * 1024 * 1024 // 50MB disk
    }

    var body: some Scene {
        WindowGroup {
           Tabview()
                .environmentObject(router)
                .environmentObject(favoriteRouter)
                .modelContainer(SwiftDataManager.shared.modelContainer)
                .modelContext(SwiftDataManager.shared.modelContext)
        }
    }
}
