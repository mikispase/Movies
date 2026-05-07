//
//  SafariView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
       // vc.preferredControlTintColor = .tintColor
        viewController.delegate = context.coordinator

        return viewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }

    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var dismissAction: DismissAction?

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            debugPrint("did finish loading initial")
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            dismissAction?()
        }
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.dismissAction = dismiss
        return coordinator
    }
}
