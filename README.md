# Markdown Reader para macOS

Simples leitor de Markdown para macOS. Abre arquivos `.md`, `.markdown` e `.mdown` e mostra o
documento renderizado — sem distração. Quando precisar ajustar algo, o botão **Editar** (⌘E) divide
a janela em editor e visualização.

- Modo edição sob demanda: editor à esquerda, visualização ao vivo à direita; salvar com ⌘S
- App nativo em SwiftUI, com uma janela por documento (abas do macOS incluídas)
- Renderização com [swift-markdown](https://github.com/swiftlang/swift-markdown) (CommonMark + GFM: tabelas, tachado, listas de tarefas)
- Tema claro e escuro acompanhando o sistema
- Imagens e links relativos ao arquivo funcionam; links para outros `.md` abrem no próprio app
- Funciona offline: nada é carregado da internet para renderizar

## Requisitos

- macOS 14 (Sonoma) ou superior
- Swift 5.9+ (Command Line Tools bastam — não precisa do Xcode)

## Compilar e instalar

```sh
./build.sh            # gera build/Markdown Reader.app
./build.sh --install  # gera e copia para /Applications
```

Para abrir arquivos `.md` com ele por padrão: clique com o botão direito num `.md` no Finder →
**Obter Informações** → **Abrir com** → *Markdown Reader* → **Alterar Tudo…**

Também dá para abrir pelo terminal:

```sh
open -a "Markdown Reader" README.md
```

## Licença

MIT — veja [LICENSE](LICENSE).
