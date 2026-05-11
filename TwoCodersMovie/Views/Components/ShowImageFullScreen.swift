//
//  ShowImageFullScreen.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI
import SDWebImageSwiftUI
#if canImport(UIKit) && !os(tvOS)
struct ShowImageFullScreen: View {
    let url: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            FullImage(url: url)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .toolbar {
#if canImport(UIKit)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.custom)
                        }
                    }
#endif

                }
        }
    }
}
#endif

#if canImport(UIKit) && !os(tvOS)
struct FullImage: View {
    let url: String

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()

                WebImage(url: URL(string: url))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(x: offset.x, y: offset.y)
                    .gesture(makeDragGesture(size: proxy.size))
                    .gesture(makeMagnificationGesture(size: proxy.size))
                    .onTapGesture(count: 2) {
                        withAnimation {
                            scale = scale > 1 ? 1 : 2
                            lastScale = scale
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value

                // To minimize jittering
                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }

    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let diff = CGPoint(
                    x: value.translation.width - lastTranslation.width,
                    y: value.translation.height - lastTranslation.height
                )
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                adjustMaxOffset(size: size)
            }
    }

    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX = (size.width * (scale - 1)) / 2
        let maxOffsetY = (size.height * (scale - 1)) / 2

        var newOffsetX = offset.x
        var newOffsetY = offset.y

        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }

        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        self.lastTranslation = .zero
    }
}
#endif
