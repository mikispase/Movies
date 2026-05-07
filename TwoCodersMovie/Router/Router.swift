//
//  Router.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import Combine

class Router: ObservableObject {
    @Published var currentView: String = ""
    @Published var current: [String] = []
    @Published var path: NavigationPath = NavigationPath()

    private var lastPathCount: Int = 0

    func append(currentView: String, value: any Hashable) {
        if value as? String == "" {
            return
        }
        debugPrint("APPEND: \(currentView) as current view")
        self.currentView = currentView
        self.current.append(currentView)
        lastPathCount = path.count
        self.path.append(value)

    }

    func detectAndProcessBack() {
        if path.count < lastPathCount {
            print("Path change: A backward navigation occurred.")
            if current.count > 0 {
                current.removeLast()
                self.currentView = current.last ?? ""
                debugPrint("REMOVE: current view \(currentView)")

            }
        }
        lastPathCount = path.count
    }

    func onBack() {
        lastPathCount = path.count - 1

        if path.count > 0 {
            path.removeLast()
        }
        if current.count > 0 {
            current.removeLast()
        }
        self.currentView = current.last ?? ""
        debugPrint("REMOVE: current view \(currentView)")
    }

    func reset() {
        lastPathCount = 0
        debugPrint("Router reset")
        path = NavigationPath()
        self.current = []
        self.currentView = ""
        lastPathCount = path.count
    }
}

public struct NavigationModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .navigationDestination(for: MovieDetailsViewModel.self, destination: { viewModel in
                MovieDetailsView(viewModel: viewModel)
            })
            .navigationDestination(for: Web.self, destination: { web in
                // Beter way is present build in SafariController
                // This is example with UIViewRepresentable
               // WebView(url: web.url)
                SafariView(url: web.url)
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            })
    }
}
