import CoreGraphics

public protocol SVGPathKitProtocol {
    func createCGPath() throws -> CGPath
}

public class SVGPathKit: SVGPathKitProtocol {

    public init() {}

    public func createCGPath() throws -> CGPath {
        CGMutablePath()
    }
}
