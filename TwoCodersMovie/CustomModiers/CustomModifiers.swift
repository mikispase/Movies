//
//  CustomModifiers.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI

struct ShadowText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(0.7),
                    radius: 3,
                    x: 0,
                    y: 2
                )
    }
}
