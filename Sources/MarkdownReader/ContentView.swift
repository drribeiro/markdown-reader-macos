import SwiftUI

/// Abre só com a visualização; o botão "Editar" (⌘E) divide a janela em editor e visualização.
struct ContentView: View {
    @Binding var document: MarkdownDocument
    let fileURL: URL?
    // `State` sem o `@`: a macro @State exige o plugin do Xcode, ausente nas Command Line Tools.
    private let editing = State(initialValue: false)
    private var isEditing: Bool { editing.wrappedValue }
    private let copied = State(initialValue: false)
    @AppStorage("theme") private var theme: Theme = .auto

    var body: some View {
        Group {
            if isEditing {
                HSplitView {
                    TextEditor(text: $document.text)
                        .font(.system(.body, design: .monospaced))
                        .autocorrectionDisabled()
                        .frame(minWidth: 240)
                    MarkdownView(text: document.text, fileURL: fileURL, theme: theme)
                        .frame(minWidth: 240)
                }
            } else {
                MarkdownView(text: document.text, fileURL: fileURL, theme: theme)
            }
        }
        .toolbar {
            Button(action: copyMarkdown) {
                Label("Copiar Markdown", systemImage: copied.wrappedValue ? "checkmark" : "doc.on.doc")
            }
            .keyboardShortcut("c", modifiers: [.command, .shift])
            .help("Copiar o Markdown para a área de transferência (⇧⌘C)")
            Menu {
                Picker("Tema", selection: $theme) {
                    ForEach(Theme.allCases) { Label($0.label, systemImage: $0.symbol).tag($0) }
                }
                .pickerStyle(.inline)
            } label: {
                Label("Tema", systemImage: theme.symbol)
            }
            .help("Tema da visualização: \(theme.label)")
            if isEditing {
                // Sem atalho próprio: o ⌘S do menu Arquivo já dispara o mesmo save.
                Button(action: save) {
                    Label("Salvar", systemImage: "square.and.arrow.down")
                }
                .help("Salvar (⌘S)")
            }
            Toggle(isOn: editing.projectedValue) {
                Label("Editar", systemImage: "square.split.2x1")
            }
            .keyboardShortcut("e", modifiers: .command)
            .help(isEditing ? "Fechar o editor (⌘E)" : "Editar ao lado da visualização (⌘E)")
        }
        .onAppear { editing.wrappedValue = document.text.isEmpty }  // documento novo já abre editando
        .onChange(of: isEditing) { _, nowEditing in
            if !nowEditing { save() }  // fechar o editor salva o que foi alterado
        }
    }

    /// Copia o texto-fonte do documento; o ícone vira um ✓ por um instante como confirmação.
    private func copyMarkdown() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(document.text, forType: .string)
        copied.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied.wrappedValue = false }
    }

    /// Envia `save:` pela cadeia de responders, que chega ao NSDocument da janela ativa.
    private func save() {
        NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: nil)
    }
}
