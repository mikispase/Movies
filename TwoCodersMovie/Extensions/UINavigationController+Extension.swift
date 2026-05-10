//
//  UINavigationController+Extension.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

#if canImport(UIKit) && !os(tvOS)
import UIKit
import SwiftUI

// This extension automatically re-enables the swipe-to-back gesture for SwiftUI NavigationStacks.
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only allow the gesture when there is a view to go back to.
        return viewControllers.count > 1
    }
}
#endif
