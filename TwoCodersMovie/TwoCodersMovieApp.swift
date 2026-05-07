//
//  TwoCodersMovieApp.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import SDWebImage

@main
struct TwoCodersMovieApp: App {
    @StateObject var router = Router()

    init() {
        SDImageCache.shared.config.maxMemoryCount = 1
        SDImageCache.shared.config.maxDiskSize = 50 * 1024 * 1024 // 50MB disk
    }

    var body: some Scene {
        WindowGroup {
           MoviesView()
                .environmentObject(router)
        }
    }
}
