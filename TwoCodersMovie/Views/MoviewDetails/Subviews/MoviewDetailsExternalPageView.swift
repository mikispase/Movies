//
//  MoviewDetailsExternalPageView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

import SwiftUI

struct MoviewDetailsExternalPageView: View {
    let url:URL
    let model:MovieDetails
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var router: Router
    
    var body: some View {
        Button {
            let urlObject = Web(url: url)
            router.append(currentView: ViewsEnum.web.rawValue, value: urlObject)
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
