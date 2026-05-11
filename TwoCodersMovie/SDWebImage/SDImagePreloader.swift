//
//  SDImagePreloader.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SDWebImage

final class SDImagePreloader {
    static let shared = SDImagePreloader()
    private let prefetcher = SDWebImagePrefetcher.shared

    private init() {
        prefetcher.maxConcurrentPrefetchCount = 3
    }

    func preload(urls: [URL]) {
        prefetcher.prefetchURLs(urls,
                                progress: nil,
                                completed: { finishedCount, skippedCount in
            debugPrint("Prefetch finished: \(finishedCount), skipped: \(skippedCount)")
        })
    }
}

protocol ImagePreloadable {
    func preloadImages(for movies: [Movie])
}

extension ImagePreloadable {
    func preloadImages(for movies: [Movie]) {
        let urls = movies.compactMap { $0.posterImage } + movies.compactMap { $0.poster780Image }
        SDImagePreloader.shared.preload(urls: urls)
    }
}
