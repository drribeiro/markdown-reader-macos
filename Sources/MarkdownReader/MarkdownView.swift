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
        let coordinator = context.coordinator
        coordinator.latestText = text
        if coordinator.isLoaded {
            // Página já carregada: troca só o conteúdo, preservando a rolagem enquanto se edita.
            coordinator.refresh(webView)
        } else if !coordinator.isLoading {
            coordinator.isLoading = true
            coordinator.renderedText = text
            let title = fileURL?.deletingPathExtension().lastPathComponent ?? "Markdown"
            // A pasta do arquivo como base faz imagens e links relativos funcionarem.
            webView.loadHTMLString(HTMLRenderer.page(for: text, title: title),
                                   baseURL: fileURL?.deletingLastPathComponent())
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var latestText = ""
        var renderedText: String?
        var isLoading = false
        var isLoaded = false

        func refresh(_ webView: WKWebView) {
            guard renderedText != latestText,
                  let json = try? JSONEncoder().encode(HTMLRenderer.body(for: latestText)),
                  let literal = String(data: json, encoding: .utf8) else { return }
            renderedText = latestText
            webView.evaluateJavaScript("document.querySelector('article').innerHTML = \(literal);")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
            isLoaded = true
            refresh(webView)  // o texto pode ter mudado durante o carregamento
        }

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
