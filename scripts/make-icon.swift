// Desenha o ícone do app em PNG 1024×1024. Uso: swift scripts/make-icon.swift saida.png
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let size = 1024
let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
                    space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(colorSpace: space, components: [r, g, b, a])!
}

func gradient(_ top: CGColor, _ bottom: CGColor) -> CGGradient {
    CGGradient(colorsSpace: space, colors: [top, bottom] as CFArray, locations: [0, 1])!
}

/// Polígono com cantos arredondados, para a folha com o canto dobrado.
func roundedPolygon(_ points: [CGPoint], radius: CGFloat) -> CGPath {
    let path = CGMutablePath()
    let n = points.count
    path.move(to: CGPoint(x: (points[0].x + points[n - 1].x) / 2, y: (points[0].y + points[n - 1].y) / 2))
    for i in 0..<n {
        path.addArc(tangent1End: points[i], tangent2End: points[(i + 1) % n], radius: radius)
    }
    path.closeSubpath()
    return path
}

// Fundo: o "squircle" padrão do macOS, com sombra e degradê índigo → violeta.
let tile = CGRect(x: 100, y: 100, width: 824, height: 824)
let tilePath = CGPath(roundedRect: tile, cornerWidth: 185, cornerHeight: 185, transform: nil)
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -14), blur: 34, color: color(0, 0, 0, 0.35))
ctx.addPath(tilePath)
ctx.setFillColor(color(0.2, 0.15, 0.5))
ctx.fillPath()
ctx.restoreGState()

ctx.saveGState()
ctx.addPath(tilePath)
ctx.clip()
ctx.drawLinearGradient(gradient(color(0.47, 0.42, 1.0), color(0.17, 0.11, 0.47)),
                       start: CGPoint(x: 0, y: tile.maxY), end: CGPoint(x: 0, y: tile.minY), options: [])
// Brilho suave no topo.
ctx.drawRadialGradient(gradient(color(1, 1, 1, 0.28), color(1, 1, 1, 0)),
                       startCenter: CGPoint(x: 512, y: 980), startRadius: 0,
                       endCenter: CGPoint(x: 512, y: 980), endRadius: 620, options: [])
ctx.restoreGState()

// Folha: canto superior direito dobrado.
let page = CGRect(x: 262, y: 196, width: 500, height: 632)
let fold: CGFloat = 118
let pagePoints = [
    CGPoint(x: page.minX, y: page.minY), CGPoint(x: page.maxX, y: page.minY),
    CGPoint(x: page.maxX, y: page.maxY - fold), CGPoint(x: page.maxX - fold, y: page.maxY),
    CGPoint(x: page.minX, y: page.maxY),
]
let pagePath = roundedPolygon(pagePoints, radius: 34)

// Folha de trás, inclinada, para dar a ideia de pilha de documentos.
ctx.saveGState()
ctx.translateBy(x: 512, y: 512)
ctx.rotate(by: -9 * .pi / 180)
ctx.translateBy(x: -512, y: -512)
ctx.setShadow(offset: CGSize(width: 0, height: -8), blur: 20, color: color(0, 0, 0, 0.25))
ctx.addPath(CGPath(roundedRect: page, cornerWidth: 34, cornerHeight: 34, transform: nil))
ctx.setFillColor(color(0.84, 0.82, 1.0, 0.42))
ctx.fillPath()
ctx.restoreGState()

// Folha da frente.
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 28, color: color(0, 0, 0, 0.32))
ctx.addPath(pagePath)
ctx.setFillColor(color(1, 1, 1))
ctx.fillPath()
ctx.restoreGState()

let foldPath = roundedPolygon([
    CGPoint(x: page.maxX - fold, y: page.maxY), CGPoint(x: page.maxX - fold, y: page.maxY - fold),
    CGPoint(x: page.maxX, y: page.maxY - fold),
], radius: 18)
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: -8, height: -8), blur: 14, color: color(0.1, 0.05, 0.35, 0.35))
ctx.addPath(foldPath)
ctx.setFillColor(color(0.8, 0.78, 0.97))
ctx.fillPath()
ctx.restoreGState()
ctx.saveGState()
ctx.addPath(foldPath)
ctx.clip()
ctx.drawLinearGradient(gradient(color(0.96, 0.95, 1.0), color(0.72, 0.69, 0.95)),
                       start: CGPoint(x: page.maxX - fold, y: page.maxY - fold),
                       end: CGPoint(x: page.maxX - fold / 2, y: page.maxY - fold / 2), options: [])
ctx.restoreGState()

// Selo do Markdown: bloco em degradê com "M↓" branco.
let badge = CGRect(x: 322, y: 478, width: 380, height: 232)
ctx.saveGState()
ctx.addPath(CGPath(roundedRect: badge, cornerWidth: 44, cornerHeight: 44, transform: nil))
ctx.clip()
ctx.drawLinearGradient(gradient(color(0.5, 0.4, 1.0), color(0.29, 0.2, 0.82)),
                       start: CGPoint(x: badge.minX, y: badge.maxY), end: CGPoint(x: badge.maxX, y: badge.minY),
                       options: [])
ctx.restoreGState()

ctx.setStrokeColor(color(1, 1, 1))
ctx.setFillColor(color(1, 1, 1))
ctx.setLineWidth(40)
ctx.setLineCap(.round)
ctx.setLineJoin(.round)
ctx.move(to: CGPoint(x: 376, y: 532))
ctx.addLine(to: CGPoint(x: 376, y: 656))
ctx.addLine(to: CGPoint(x: 440, y: 586))
ctx.addLine(to: CGPoint(x: 504, y: 656))
ctx.addLine(to: CGPoint(x: 504, y: 532))
ctx.strokePath()

ctx.move(to: CGPoint(x: 618, y: 656))
ctx.addLine(to: CGPoint(x: 618, y: 596))
ctx.strokePath()
ctx.addPath(roundedPolygon([
    CGPoint(x: 562, y: 604), CGPoint(x: 674, y: 604), CGPoint(x: 618, y: 524),
], radius: 10))
ctx.fillPath()

// Linhas de texto.
ctx.setFillColor(color(0.82, 0.82, 0.93))
for (y, width) in [(CGFloat(398), CGFloat(380)), (324, 320), (250, 352)] {
    ctx.addPath(CGPath(roundedRect: CGRect(x: 322, y: y, width: width, height: 34),
                       cornerWidth: 17, cornerHeight: 17, transform: nil))
    ctx.fillPath()
}

let out = URL(fileURLWithPath: CommandLine.arguments[1])
let dest = CGImageDestinationCreateWithURL(out as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
