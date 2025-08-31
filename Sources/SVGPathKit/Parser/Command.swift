import Foundation

enum Command: Equatable {
    case moveTo(x: CGFloat, y: CGFloat, relative: Bool)
    case lineTo(x: CGFloat, y: CGFloat, relative: Bool)
    case horizontalLineTo(x: CGFloat, relative: Bool)
    case verticalLineTo(y: CGFloat, relative: Bool)
    case curveTo(
        x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, x: CGFloat, y: CGFloat, relative: Bool)
    case smoothCurveTo(x2: CGFloat, y2: CGFloat, x: CGFloat, y: CGFloat, relative: Bool)
    case quadraticCurveTo(x1: CGFloat, y1: CGFloat, x: CGFloat, y: CGFloat, relative: Bool)
    case smoothQuadraticCurveTo(x: CGFloat, y: CGFloat, relative: Bool)
    case arcTo(
        rx: CGFloat, ry: CGFloat, rotation: CGFloat, largeArc: Bool, sweep: Bool, x: CGFloat,
        y: CGFloat, relative: Bool)
    case closePath
}
