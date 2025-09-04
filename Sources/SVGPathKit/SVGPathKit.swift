import CoreGraphics

/// A protocol defining the core functionality of SVG path processing.
public protocol SVGPathKitProtocol {
    /// Creates a `CGPath` from the SVG path data.
    /// - Returns: A `CGPath` representation of the SVG path
    /// - Throws: An error if the path data is invalid or cannot be processed
    func createCGPath() throws -> CGPath
}

/// A Swift library for parsing and rendering SVG path data into CoreGraphics paths.
///
/// `SVGPathKit` provides a complete solution for processing SVG path data strings and converting them
/// into `CGPath` objects that can be used with CoreGraphics and UIKit/AppKit drawing operations.
///
/// The library supports all SVG 2.0 path commands including:
/// - Move commands (M, m)
/// - Line commands (L, l, H, h, V, v)
/// - Cubic Bézier curves (C, c, S, s)
/// - Quadratic Bézier curves (Q, q, T, t)
/// - Elliptical arcs (A, a)
/// - Close path (Z, z)
///
/// ## Example Usage
///
/// ```swift
/// let pathKit = SVGPathKit(path: "M 10 10 L 20 20 Z")
/// let cgPath = try pathKit.createCGPath()
/// ```
///
/// - Note: The library follows SVG 2.0 specification for path data processing.
/// - Since: iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0
public class SVGPathKit: SVGPathKitProtocol {
    /// The SVG path data string to be processed.
    ///
    /// This string should contain valid SVG path data using standard SVG path syntax.
    /// The string will be tokenized, parsed, validated, and rendered when `createCGPath()` is called.
    public var pathString: String
    
    private let tokenizer: Tokenizing
    private let parser: Parsing
    private let validator: Validating
    private let renderer: Renderer

    /// Creates a new SVGPathKit instance with the specified path data.
    /// 
    /// - Parameter path: A string containing SVG path data using standard SVG path syntax
    /// 
    /// ## Example
    /// ```swift
    /// let simpleRect = SVGPathKit(path: "M 0 0 H 100 V 100 H 0 Z")
    /// let complexPath = SVGPathKit(path: "M 10,10 C 20,20 40,20 50,10 S 80,0 90,10")
    /// ```
    public init(path: String) {
        self.pathString = path
        self.tokenizer = Tokenizer()
        self.parser = Parser()
        self.validator = Validator()
        self.renderer = PathRenderer()
    }
    
    init(
        pathString: String = "",
        tokenizer: Tokenizing = Tokenizer(),
        parser: Parsing = Parser(),
        validator: Validating = Validator(),
        renderer: Renderer = PathRenderer()
    ) {
        self.pathString = pathString
        self.tokenizer = tokenizer
        self.parser = parser
        self.validator = validator
        self.renderer = renderer
    }

    /// Processes the SVG path data and creates a corresponding `CGPath`.
    ///
    /// This method performs the complete SVG path processing pipeline:
    /// 1. **Tokenization**: Breaks the path string into tokens
    /// 2. **Parsing**: Converts tokens into path commands
    /// 3. **Validation**: Ensures the command sequence is valid according to SVG 2.0 spec
    /// 4. **Rendering**: Converts commands into CoreGraphics path operations
    ///
    /// - Returns: A `CGPath` object representing the SVG path
    /// - Throws: 
    ///   - `TokenError` if the path string contains invalid tokens
    ///   - `ParserError` if the command sequence cannot be parsed
    ///   - `ValidatorError` if the path violates SVG specification rules
    ///
    /// ## Example
    /// ```swift
    /// let pathKit = SVGPathKit(path: "M 10 10 L 50 10 L 30 50 Z")
    /// do {
    ///     let cgPath = try pathKit.createCGPath()
    ///     // Use cgPath with CoreGraphics or UIKit/AppKit
    /// } catch {
    ///     print("Failed to create path: \(error)")
    /// }
    /// ```
    public func createCGPath() throws -> CGPath {
        let tokens = try tokenizer.tokenize(pathString)
        let commands = try parser.parse(tokens)
        try validator.validate(commands)
        return renderer.render(commands)
    }
}
