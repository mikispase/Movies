//
//  SafariView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
#if canImport(UIKit) && !os(tvOS)
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
       // vc.preferredControlTintColor = .tintColor
        #if !os(visionOS)
        viewController.delegate = context.coordinator
        #endif

        return viewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }

    #if !os(visionOS)
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var dismissAction: DismissAction?

        func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            debugPrint("did finish loading initial")
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            dismissAction?()
        }
    }
    #endif

    #if !os(visionOS)
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.dismissAction = dismiss
        return coordinator
    }
    #endif
}
#endif
