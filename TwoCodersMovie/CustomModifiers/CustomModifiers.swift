//
//  CustomModifiers.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

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

struct MatchedTransitionSource<ID: Hashable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .matchedTransitionSource(id: id, in: namespace)
        } else {
            content
        }
    }
}

struct AnimationTransition<ID: Hashable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        } else {
            content
        }
    }
}

struct ScrollTargetLayout: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .scrollTargetLayout()
        } else {
            content
        }
    }
}

struct ScrollPaging: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .contentMargins(.horizontal, 16)
                .scrollBounceBehavior(.always)
                .scrollTargetBehavior(.viewAligned)
        } else {
            content.padding(.horizontal, 16)
        }
    }
}

struct NavigationTitleInline: ViewModifier {
    func body(content: Content) -> some View {
#if !os(tvOS)
        content.navigationBarTitleDisplayMode(.inline)
        #else
        content
#endif
    }
}

struct SearchableModifier: ViewModifier {
    @Binding var text:String
    
    func body(content: Content) -> some View {
#if !os(tvOS)
        content
            .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .automatic))
#else
        content
#endif
        
    }
}

struct SearchableScopeModifier: ViewModifier {
    @Binding var searchScope:SearchScope
    
    func body(content: Content) -> some View {
#if !os(tvOS)
        content
            .searchScopes($searchScope, activation: .onSearchPresentation) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue.capitalized)
                }
            }
#else
        content
#endif
    }
}
