//
//  PosterImage.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct PosterImage: View {
    var url: URL?
    var placeholder: String  = "placeholder"
    var fit: Bool  = false
    var addBlur: Bool  = false

    var body: some View {
        GeometryReader { geometry in
            WebImage(url: url) { image in
                image
                    .resizable()
                    .if(fit) { view in
                        view.scaledToFit()
                    }
                    .if(!fit) { view in
                        view.scaledToFill()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .background(
                        Color.gray.opacity(0.1)
                    )
            } placeholder: {
                if placeholder == "" {
                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundStyle(.clear)
                        .background(Color.gray.opacity(0.1))
                } else {
                    Image(placeholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }
            .if(addBlur) { view in
                view.blur(radius: 40, opaque: true)
            }
        }
    }
}
