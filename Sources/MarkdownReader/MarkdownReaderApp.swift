import SwiftUI

@main
struct MarkdownReaderApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument()) { file in
            ContentView(document: file.$document, fileURL: file.fileURL)
                .frame(minWidth: 480, minHeight: 360)
        }
    }
}
