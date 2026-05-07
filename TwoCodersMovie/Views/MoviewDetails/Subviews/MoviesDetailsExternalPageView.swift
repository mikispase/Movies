//
//  MoviesDetailsExternalPageView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MoviesDetailsExternalPageView: View {
    let url:URL
    let model:MovieDetails
    let routerType:RouterType
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var router: Router
    @EnvironmentObject var favoriteRouter: FavoriteRouter

    var body: some View {
        Button {
            let urlObject = Web(url: url)
            switch routerType {
            case .home:
                router.append(currentView: ViewsEnum.web.rawValue, value: urlObject)
            case .favorite:
                favoriteRouter.append(currentView: ViewsEnum.web.rawValue, value: urlObject)
            }
        }label: {
            FlowHStack(horizontalSpacing: 3, verticalSpacing: 0) {
                Text("If you want se see more about")
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                Text("\(model.originalTitle ?? "")")
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                Text("Visit original page")
                    .underline()
                    .foregroundStyle(colorScheme == .light ? .black : .white)
            }
        }
        .padding(.top)
    }
}
