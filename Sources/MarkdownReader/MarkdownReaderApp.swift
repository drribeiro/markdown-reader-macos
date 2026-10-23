import SwiftUI

@main
struct MarkdownReaderApp: App {
    var body: some Scene {
        DocumentGroup(viewing: MarkdownDocument.self) { file in
            MarkdownView(text: file.document.text, fileURL: file.fileURL)
                .frame(minWidth: 480, minHeight: 360)
        }
    }
}
