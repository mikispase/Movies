//
//  WebView.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

#if canImport(UIKit)
import UIKit
import SwiftUI
import SafariServices
import WebKit

struct WebView: UIViewRepresentable {
    @Environment(\.dismiss) var dismiss

    let url: URL

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.dismissAction = dismiss
        return coordinator
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url == nil {
            webView.load(URLRequest(url: url))
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var dismissAction: DismissAction?

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let absoluteString = navigationAction.request.url?.absoluteString else {
                decisionHandler(.allow)
                return
            }
            debugPrint(absoluteString)

            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            debugPrint("webview finished loading: \(webView.url?.absoluteString ?? "")")
        }
    }
}
#endif
