import Foundation
import Markdown

enum HTMLRenderer {
    static func page(for markdown: String, title: String) -> String {
        let body = HTMLFormatter.format(markdown)
        return """
        <!doctype html>
        <html lang="pt-BR">
        <head>
        <meta charset="utf-8">
        <title>\(escape(title))</title>
        <style>\(stylesheet)</style>
        </head>
        <body><article>\(body)</article></body>
        </html>
        """
    }

    private static func escape(_ s: String) -> String {
        s.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }

    private static let stylesheet = """
    :root {
      color-scheme: light dark;
      --fg: #1f2328; --muted: #59636e; --bg: #ffffff;
      --border: #d1d9e0; --code-bg: #f6f8fa; --link: #0969da;
    }
    @media (prefers-color-scheme: dark) {
      :root {
        --fg: #e6edf3; --muted: #9198a1; --bg: #1e1e1e;
        --border: #3d444d; --code-bg: #2a2d31; --link: #4493f8;
      }
    }
    html { background: var(--bg); }
    body {
      margin: 0; color: var(--fg);
      font: 15px/1.6 -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif;
    }
    article { max-width: 820px; margin: 0 auto; padding: 32px 40px 64px; }
    h1, h2, h3, h4, h5, h6 { margin: 1.5em 0 0.6em; line-height: 1.25; font-weight: 600; }
    h1 { font-size: 2em; padding-bottom: .3em; border-bottom: 1px solid var(--border); }
    h2 { font-size: 1.5em; padding-bottom: .3em; border-bottom: 1px solid var(--border); }
    h3 { font-size: 1.25em; }
    article > :first-child { margin-top: 0; }
    p, ul, ol, blockquote, pre, table { margin: 0 0 1em; }
    a { color: var(--link); text-decoration: none; }
    a:hover { text-decoration: underline; }
    code, pre { font: 0.88em/1.45 ui-monospace, "SF Mono", Menlo, monospace; }
    code { background: var(--code-bg); padding: .15em .35em; border-radius: 5px; }
    pre { background: var(--code-bg); padding: 14px 16px; border-radius: 8px; overflow: auto; }
    pre code { background: none; padding: 0; font-size: 1em; }
    blockquote { margin-left: 0; padding: 0 1em; color: var(--muted); border-left: 4px solid var(--border); }
    table { border-collapse: collapse; display: block; overflow: auto; }
    th, td { border: 1px solid var(--border); padding: 6px 13px; }
    th { background: var(--code-bg); font-weight: 600; }
    img { max-width: 100%; }
    hr { border: 0; border-top: 1px solid var(--border); margin: 2em 0; }
    li > input[type=checkbox] { margin-right: .4em; }
    """
}
