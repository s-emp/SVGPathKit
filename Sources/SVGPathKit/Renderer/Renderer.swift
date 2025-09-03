import CoreGraphics

protocol Renderer {
    func render(_ tokens: [Command]) -> CGPath
}

final class PathRenderer: Renderer {
    func render(_ commands: [Command]) -> CGPath {
        let path = CGMutablePath()
        var currentPoint = CGPoint.zero
        
        for command in commands {
            switch command {
            case let .moveTo(x, y, relative):
                let point = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.move(to: point)
                currentPoint = point
                
            case let .lineTo(x, y, relative):
                let point = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addLine(to: point)
                currentPoint = point
                
            case let .horizontalLineTo(x, relative):
                let point = CGPoint(x: relative ? currentPoint.x + x : x, y: currentPoint.y)
                path.addLine(to: point)
                currentPoint = point
                
            case let .verticalLineTo(y, relative):
                let point = CGPoint(x: currentPoint.x, y: relative ? currentPoint.y + y : y)
                path.addLine(to: point)
                currentPoint = point
                
            case let .curveTo(x1, y1, x2, y2, x, y, relative):
                let cp1 = relative ? CGPoint(x: currentPoint.x + x1, y: currentPoint.y + y1) : CGPoint(x: x1, y: y1)
                let cp2 = relative ? CGPoint(x: currentPoint.x + x2, y: currentPoint.y + y2) : CGPoint(x: x2, y: y2)
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addCurve(to: endPoint, control1: cp1, control2: cp2)
                currentPoint = endPoint
                
            case let .smoothCurveTo(x2, y2, x, y, relative):
                let cp2 = relative ? CGPoint(x: currentPoint.x + x2, y: currentPoint.y + y2) : CGPoint(x: x2, y: y2)
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addCurve(to: endPoint, control1: currentPoint, control2: cp2)
                currentPoint = endPoint
                
            case let .quadraticCurveTo(x1, y1, x, y, relative):
                let cp = relative ? CGPoint(x: currentPoint.x + x1, y: currentPoint.y + y1) : CGPoint(x: x1, y: y1)
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addQuadCurve(to: endPoint, control: cp)
                currentPoint = endPoint
                
            case let .smoothQuadraticCurveTo(x, y, relative):
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addQuadCurve(to: endPoint, control: currentPoint)
                currentPoint = endPoint
                
            case .arcTo:
                // TODO: Implement arc rendering
                break
                
            case .closePath:
                path.closeSubpath()
            }
        }
        
        return path
    }
}
