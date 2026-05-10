//
//  Tabview.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

enum TabbarSelection {
    case discover
    case favorite
    case search
}

struct Tabview:View {
    @EnvironmentObject var router: Router
    
    @State var selectedTab: TabbarSelection = .discover
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Explore", systemImage: "safari.fill", value: TabbarSelection.discover) {
                MoviesView()
            }
            
            Tab("Favorite", systemImage: "heart", value: TabbarSelection.favorite) {
                FavoriteView()
            }
            
            if !embederdSearchInMainView {
                Tab("Search", systemImage: "magnifyingglass", value: TabbarSelection.search) {
                    SearchView()
                }
            }
        }
        .if(UIDevice.isIpad) {view in
            view.environment(\.horizontalSizeClass, .compact)
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
