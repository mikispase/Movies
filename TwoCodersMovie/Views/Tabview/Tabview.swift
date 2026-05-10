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
        if #available(iOS 18, *) {
            NewTabbar(selectedTab: $selectedTab)
        } else {
           OldTabbar(selectedTab: $selectedTab)
        }
    }
}

@available(iOS 18.0, *)
struct NewTabbar: View {
    @Binding var selectedTab:TabbarSelection
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Tab("Trending", systemImage: "safari.fill", value: TabbarSelection.discover) {
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
#if !os(tvOS)
        .tabViewStyle(.sidebarAdaptable)
#endif

    }
}

struct OldTabbar: View {
    @Binding var selectedTab:TabbarSelection
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesView()
                .tabItem {
                    Image(systemName: "safari.fill")
                        .frame(width: 30, height: 30)
                    Text("Trending")
                        .font(.system(size: 18))
                }
                .tag(TabbarSelection.discover)
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart")
                        .frame(width: 30, height: 30)
                    Text("Favorite")
                        .font(.system(size: 18))
                }
                .tag(TabbarSelection.favorite)
            
            if !embederdSearchInMainView {
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 30, height: 30)
                        Text("Search")
                            .font(.system(size: 18))
                    }
                    .tag(TabbarSelection.search)
            }
        }
        .if(UIDevice.isIpad) {view in
            view.environment(\.horizontalSizeClass, .compact)
        }
    }
}
