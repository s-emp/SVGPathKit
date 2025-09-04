import CoreGraphics

protocol Renderer {
    func render(_ tokens: [Command]) -> CGPath
}

final class PathRenderer: Renderer {
    func render(_ commands: [Command]) -> CGPath {
        let path = CGMutablePath()
        var currentPoint = CGPoint.zero
        var lastControlPoint: CGPoint?
        var previousCommand: Command?
        
        for command in commands {
            switch command {
            case let .moveTo(x, y, relative):
                let point = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.move(to: point)
                currentPoint = point
                lastControlPoint = nil
                
            case let .lineTo(x, y, relative):
                let point = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addLine(to: point)
                currentPoint = point
                lastControlPoint = nil
                
            case let .horizontalLineTo(x, relative):
                let point = CGPoint(x: relative ? currentPoint.x + x : x, y: currentPoint.y)
                path.addLine(to: point)
                currentPoint = point
                lastControlPoint = nil
                
            case let .verticalLineTo(y, relative):
                let point = CGPoint(x: currentPoint.x, y: relative ? currentPoint.y + y : y)
                path.addLine(to: point)
                currentPoint = point
                lastControlPoint = nil
                
            case let .curveTo(x1, y1, x2, y2, x, y, relative):
                let cp1 = relative ? CGPoint(x: currentPoint.x + x1, y: currentPoint.y + y1) : CGPoint(x: x1, y: y1)
                let cp2 = relative ? CGPoint(x: currentPoint.x + x2, y: currentPoint.y + y2) : CGPoint(x: x2, y: y2)
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addCurve(to: endPoint, control1: cp1, control2: cp2)
                currentPoint = endPoint
                lastControlPoint = cp2
                
            case let .smoothCurveTo(x2, y2, x, y, relative):
                let cp2 = relative ? CGPoint(x: currentPoint.x + x2, y: currentPoint.y + y2) : CGPoint(x: x2, y: y2)
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                
                // Calculate reflected control point if previous command was C, c, S, or s
                let cp1: CGPoint
                if let lastCP = lastControlPoint,
                   let prevCmd = previousCommand {
                    switch prevCmd {
                    case .curveTo, .smoothCurveTo:
                        // Reflect the last control point relative to current point
                        cp1 = CGPoint(x: 2 * currentPoint.x - lastCP.x, y: 2 * currentPoint.y - lastCP.y)
                    default:
                        // If no previous curve command, use current point as first control point
                        cp1 = currentPoint
                    }
                } else {
                    // If no previous curve command, use current point as first control point
                    cp1 = currentPoint
                }
                
                path.addCurve(to: endPoint, control1: cp1, control2: cp2)
                currentPoint = endPoint
                lastControlPoint = cp2
                
            case let .quadraticCurveTo(x1, y1, x, y, relative):
                let cp = relative ? CGPoint(x: currentPoint.x + x1, y: currentPoint.y + y1) : CGPoint(x: x1, y: y1)
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                path.addQuadCurve(to: endPoint, control: cp)
                currentPoint = endPoint
                lastControlPoint = cp
                
            case let .smoothQuadraticCurveTo(x, y, relative):
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                
                // Calculate reflected control point if previous command was Q, q, T, or t
                let cp: CGPoint
                if let lastCP = lastControlPoint,
                   let prevCmd = previousCommand {
                    switch prevCmd {
                    case .quadraticCurveTo, .smoothQuadraticCurveTo:
                        // Reflect the last control point relative to current point
                        cp = CGPoint(x: 2 * currentPoint.x - lastCP.x, y: 2 * currentPoint.y - lastCP.y)
                    default:
                        // If no previous quadratic command, use current point as control point
                        cp = currentPoint
                    }
                } else {
                    // If no previous quadratic command, use current point as control point
                    cp = currentPoint
                }
                
                path.addQuadCurve(to: endPoint, control: cp)
                currentPoint = endPoint
                lastControlPoint = cp
                
            case let .arcTo(rx, ry, rotation, largeArc, sweep, x, y, relative):
                // https://mortoray.com/rendering-an-svg-elliptical-arc-as-bezier-curves/
                let endPoint = relative ? CGPoint(x: currentPoint.x + x, y: currentPoint.y + y) : CGPoint(x: x, y: y)
                renderArc(
                    path: path,
                    from: currentPoint,
                    to: endPoint,
                    rx: rx,
                    ry: ry,
                    xAxisRotation: rotation,
                    largeArcFlag: largeArc,
                    sweepFlag: sweep
                )
                currentPoint = endPoint
                lastControlPoint = nil
                
            case .closePath:
                path.closeSubpath()
                lastControlPoint = nil
            }
            
            previousCommand = command
        }
        
        return path
    }
    
    // MARK: - Arc Rendering Implementation
    
    private func renderArc(
        path: CGMutablePath,
        from startPoint: CGPoint,
        to endPoint: CGPoint,
        rx: CGFloat,
        ry: CGFloat,
        xAxisRotation: CGFloat,
        largeArcFlag: Bool,
        sweepFlag: Bool
    ) {
        // Handle degenerate cases
        guard rx > 0 && ry > 0 else {
            path.addLine(to: endPoint)
            return
        }
        
        guard startPoint != endPoint else {
            return
        }
        
        // Convert SVG arc parameters to center point parametrization
        let center = endpointToCenterArcParams(
            startPoint: startPoint,
            endPoint: endPoint,
            rx: rx,
            ry: ry,
            xAxisRotation: xAxisRotation,
            largeArcFlag: largeArcFlag,
            sweepFlag: sweepFlag
        )
        
        // Convert the arc to bezier curves
        convertArcToBeziers(
            path: path,
            center: center.center,
            rx: center.rx,
            ry: center.ry,
            xAxisRotation: xAxisRotation,
            startAngle: center.startAngle,
            endAngle: center.endAngle,
            sweep: sweepFlag
        )
    }
    
    private struct ArcParams {
        let center: CGPoint
        let rx: CGFloat
        let ry: CGFloat
        let startAngle: CGFloat
        let endAngle: CGFloat
    }
    
    private func endpointToCenterArcParams(
        startPoint: CGPoint,
        endPoint: CGPoint,
        rx: CGFloat,
        ry: CGFloat,
        xAxisRotation: CGFloat,
        largeArcFlag: Bool,
        sweepFlag: Bool
    ) -> ArcParams {
        let rotationRadians = xAxisRotation * .pi / 180.0
        let cosRotation = cos(rotationRadians)
        let sinRotation = sin(rotationRadians)
        
        // Step 1: Compute (x1', y1')
        let dx = (startPoint.x - endPoint.x) / 2.0
        let dy = (startPoint.y - endPoint.y) / 2.0
        let x1Prime = cosRotation * dx + sinRotation * dy
        let y1Prime = -sinRotation * dx + cosRotation * dy
        
        // Step 2: Ensure radii are large enough
        var rxAbs = abs(rx)
        var ryAbs = abs(ry)
        let rxSquared = rxAbs * rxAbs
        let rySquared = ryAbs * ryAbs
        let x1PrimeSquared = x1Prime * x1Prime
        let y1PrimeSquared = y1Prime * y1Prime
        
        let lambda = x1PrimeSquared / rxSquared + y1PrimeSquared / rySquared
        if lambda > 1 {
            let sqrtLambda = sqrt(lambda)
            rxAbs *= sqrtLambda
            ryAbs *= sqrtLambda
        }
        
        // Step 3: Compute center point
        let rxSquaredNew = rxAbs * rxAbs
        let rySquaredNew = ryAbs * ryAbs
        let numerator = rxSquaredNew * rySquaredNew - rxSquaredNew * y1PrimeSquared - rySquaredNew * x1PrimeSquared
        let denominator = rxSquaredNew * y1PrimeSquared + rySquaredNew * x1PrimeSquared
        
        let coeff = sqrt(max(0, numerator / denominator))
        let sign: CGFloat = largeArcFlag != sweepFlag ? 1 : -1
        
        let cxPrime = sign * coeff * (rxAbs * y1Prime / ryAbs)
        let cyPrime = sign * coeff * -(ryAbs * x1Prime / rxAbs)
        
        // Step 4: Compute center (cx, cy) from (cx', cy')
        let cx = cosRotation * cxPrime - sinRotation * cyPrime + (startPoint.x + endPoint.x) / 2.0
        let cy = sinRotation * cxPrime + cosRotation * cyPrime + (startPoint.y + endPoint.y) / 2.0
        
        // Step 5: Compute angles
        let startAngle = atan2((y1Prime - cyPrime) / ryAbs, (x1Prime - cxPrime) / rxAbs)
        let deltaAngle = atan2((-y1Prime - cyPrime) / ryAbs, (-x1Prime - cxPrime) / rxAbs) - startAngle
        
        var endAngle = startAngle + deltaAngle
        
        // Adjust angles based on sweep direction
        if sweepFlag && deltaAngle < 0 {
            endAngle += 2 * .pi
        } else if !sweepFlag && deltaAngle > 0 {
            endAngle -= 2 * .pi
        }
        
        return ArcParams(
            center: CGPoint(x: cx, y: cy),
            rx: rxAbs,
            ry: ryAbs,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }
    
    private func convertArcToBeziers(
        path: CGMutablePath,
        center: CGPoint,
        rx: CGFloat,
        ry: CGFloat,
        xAxisRotation: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        sweep: Bool
    ) {
        let rotationRadians = xAxisRotation * .pi / 180.0
        let totalAngle = abs(endAngle - startAngle)
        let numSegments = max(1, Int(ceil(totalAngle / (.pi / 2))))
        let segmentAngle = (endAngle - startAngle) / CGFloat(numSegments)
        
        var currentAngle = startAngle
        
        for _ in 0..<numSegments {
            let nextAngle = currentAngle + segmentAngle
            addBezierSegment(
                path: path,
                center: center,
                rx: rx,
                ry: ry,
                xAxisRotation: rotationRadians,
                startAngle: currentAngle,
                endAngle: nextAngle
            )
            currentAngle = nextAngle
        }
    }
    
    private func addBezierSegment(
        path: CGMutablePath,
        center: CGPoint,
        rx: CGFloat,
        ry: CGFloat,
        xAxisRotation: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat
    ) {
        let cosRotation = cos(xAxisRotation)
        let sinRotation = sin(xAxisRotation)
        
        // Calculate control point distance for cubic Bezier approximation
        let alpha = sin(endAngle - startAngle) * (sqrt(4 + 3 * tan((endAngle - startAngle) / 2) * tan((endAngle - startAngle) / 2)) - 1) / 3
        
        // Calculate points on the unit circle
        let cosStart = cos(startAngle)
        let sinStart = sin(startAngle)
        let cosEnd = cos(endAngle)
        let sinEnd = sin(endAngle)
        
        // Unit circle control points
        let q1 = CGPoint(x: cosStart, y: sinStart)
        let q2 = CGPoint(x: cosStart - alpha * sinStart, y: sinStart + alpha * cosStart)
        let q3 = CGPoint(x: cosEnd + alpha * sinEnd, y: sinEnd - alpha * cosEnd)
        let q4 = CGPoint(x: cosEnd, y: sinEnd)
        
        // Transform to ellipse and rotate
        let points = [q1, q2, q3, q4].map { point in
            let ex = rx * point.x
            let ey = ry * point.y
            return CGPoint(
                x: center.x + cosRotation * ex - sinRotation * ey,
                y: center.y + sinRotation * ex + cosRotation * ey
            )
        }
        
        path.addCurve(to: points[3], control1: points[1], control2: points[2])
    }
}
