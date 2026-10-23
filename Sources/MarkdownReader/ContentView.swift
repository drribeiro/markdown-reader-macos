import SwiftUI

/// Abre só com a visualização; o botão "Editar" (⌘E) divide a janela em editor e visualização.
struct ContentView: View {
    @Binding var document: MarkdownDocument
    let fileURL: URL?
    // `State` sem o `@`: a macro @State exige o plugin do Xcode, ausente nas Command Line Tools.
    private let editing = State(initialValue: false)
    private var isEditing: Bool { editing.wrappedValue }

    var body: some View {
        Group {
            if isEditing {
                HSplitView {
                    TextEditor(text: $document.text)
                        .font(.system(.body, design: .monospaced))
                        .autocorrectionDisabled()
                        .frame(minWidth: 240)
                    MarkdownView(text: document.text, fileURL: fileURL)
                        .frame(minWidth: 240)
                }
            } else {
                MarkdownView(text: document.text, fileURL: fileURL)
            }
        }
        .toolbar {
            Toggle(isOn: editing.projectedValue) {
                Label("Editar", systemImage: "square.split.2x1")
            }
            .keyboardShortcut("e", modifiers: .command)
            .help(isEditing ? "Fechar o editor (⌘E)" : "Editar ao lado da visualização (⌘E)")
        }
        .onAppear { editing.wrappedValue = document.text.isEmpty }  // documento novo já abre editando
    }
}
