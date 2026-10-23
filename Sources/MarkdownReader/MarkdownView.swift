import AppKit
import SwiftUI
import WebKit

struct MarkdownView: NSViewRepresentable {
    let text: String
    let fileURL: URL?

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.renderedText != text else { return }
        context.coordinator.renderedText = text
        let title = fileURL?.deletingPathExtension().lastPathComponent ?? "Markdown"
        // A pasta do arquivo como base faz imagens e links relativos funcionarem.
        webView.loadHTMLString(HTMLRenderer.page(for: text, title: title),
                               baseURL: fileURL?.deletingLastPathComponent())
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var renderedText: String?

        func webView(_ webView: WKWebView,
                     decidePolicyFor action: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard action.navigationType == .linkActivated, let url = action.request.url else {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
            if url.isFileURL, ["md", "markdown", "mdown"].contains(url.pathExtension.lowercased()) {
                NSDocumentController.shared.openDocument(withContentsOf: url, display: true) { _, _, _ in }
            } else {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
