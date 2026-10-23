import AppKit

/// Tema da visualização. `auto` acompanha o modo claro/escuro do sistema.
enum Theme: String, CaseIterable, Identifiable {
    case auto, light, dark, sepia

    var id: String { rawValue }

    var label: String {
        switch self {
        case .auto: "Automático"
        case .light: "Claro"
        case .dark: "Escuro"
        case .sepia: "Papel"
        }
    }

    var symbol: String {
        switch self {
        case .auto: "circle.lefthalf.filled"
        case .light: "sun.max"
        case .dark: "moon"
        case .sepia: "book"
        }
    }

    /// Aparência forçada na web view, para a barra de rolagem combinar com o fundo.
    var appearance: NSAppearance? {
        switch self {
        case .auto: nil
        case .dark: NSAppearance(named: .darkAqua)
        case .light, .sepia: NSAppearance(named: .aqua)
        }
    }
}
