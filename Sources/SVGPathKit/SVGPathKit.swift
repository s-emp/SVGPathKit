import CoreGraphics

public protocol SVGPathKitProtocol {
    func createCGPath() throws -> CGPath
}

public class SVGPathKit: SVGPathKitProtocol {
    public var pathString: String
    
    private let tokenizer: Tokenizing
    private let parser: Parsing
    private let validator: Validating
    private let renderer: Renderer

    public init(path: String) {
        self.pathString = path
        self.tokenizer = Tokenize()
        self.parser = Parser()
        self.validator = Validator()
        self.renderer = PathRenderer()
    }
    
    init(
        pathString: String = "",
        tokenizer: Tokenizing = Tokenize(),
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

    public func createCGPath() throws -> CGPath {
        let tokens = try tokenizer.tokenize(pathString)
        let commands = try parser.parse(tokens)
        try validator.validate(commands)
        return renderer.render(commands)
    }
}
