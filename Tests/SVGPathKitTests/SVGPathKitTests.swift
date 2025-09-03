import Testing

@testable import SVGPathKit

@Test(
    "SVG Path commands lookup table returns true for valid command ASCII codes",
    arguments: [
        (77, "M - Move to absolute"),
        (109, "m - Move to relative"),
        (76, "L - Line to absolute"),
        (108, "l - Line to relative"),
        (72, "H - Horizontal line to absolute"),
        (104, "h - Horizontal line to relative"),
        (86, "V - Vertical line to absolute"),
        (118, "v - Vertical line to relative"),
        (67, "C - Cubic Bézier curve absolute"),
        (99, "c - Cubic Bézier curve relative"),
        (83, "S - Smooth cubic Bézier curve absolute"),
        (115, "s - Smooth cubic Bézier curve relative"),
        (81, "Q - Quadratic Bézier curve absolute"),
        (113, "q - Quadratic Bézier curve relative"),
        (84, "T - Smooth quadratic Bézier curve absolute"),
        (116, "t - Smooth quadratic Bézier curve relative"),
        (65, "A - Elliptical arc absolute"),
        (97, "a - Elliptical arc relative"),
        (90, "Z - Close path"),
        (122, "z - Close path")
    ]
)
func validSVGPathCommandsReturnTrue(code: Int, description: String) async throws {
    #expect(
        SVGPathKit.svgPathCommands[code],
        "ASCII code \(code) (\(description)) should be recognized as valid SVG path command"
    )
}

@Test(
    "SVG number start characters lookup table returns true for valid numeric ASCII codes",
    arguments: [
        (48, "0 - Digit zero"),
        (49, "1 - Digit one"),
        (50, "2 - Digit two"),
        (51, "3 - Digit three"),
        (52, "4 - Digit four"),
        (53, "5 - Digit five"),
        (54, "6 - Digit six"),
        (55, "7 - Digit seven"),
        (56, "8 - Digit eight"),
        (57, "9 - Digit nine"),
        (43, "+ - Plus sign"),
        (45, "- - Minus sign"),
        (46, ". - Decimal point")
    ]
)
func validNumberStartCharactersReturnTrue(code: Int, description: String) async throws {
    #expect(
        SVGPathKit.svgNumberStartChars[code],
        "ASCII code \(code) (\(description)) should be recognized as valid number start character"
    )
}

@Test("Create CGPath from simple path string")
func testCreateCGPathSimple() async throws {
    let svgPathKit = SVGPathKit(path: "M 10 20 L 30 40 Z")
    let path = try svgPathKit.createCGPath()
    
    #expect(path.isEmpty == false)
}

@Test("Create CGPath from complex path string")
func testCreateCGPathComplex() async throws {
    let pathString = "M 0 0 L 10 10 H 20 V 30 C 25 25 30 30 35 35 S 40 40 45 45 Q 50 50 55 55 T 60 60 Z"
    let svgPathKit = SVGPathKit(path: pathString)
    let path = try svgPathKit.createCGPath()
    
    #expect(path.isEmpty == false)
}

@Test("Create CGPath from relative coordinates")
func testCreateCGPathRelative() async throws {
    let pathString = "M 10 10 l 5 5 h 10 v 10 c 5 5 10 10 15 15 z"
    let svgPathKit = SVGPathKit(path: pathString)
    let path = try svgPathKit.createCGPath()
    
    #expect(path.isEmpty == false)
}

@Test("Create CGPath throws error for invalid path")
func testCreateCGPathInvalid() async throws {
    let svgPathKit = SVGPathKit(path: "L 10 20")
    
    #expect(throws: ValidatorError.self) {
        try svgPathKit.createCGPath()
    }
}

@Test("Create CGPath throws error for empty path")
func testCreateCGPathEmpty() async throws {
    let svgPathKit = SVGPathKit(path: "")
    
    #expect(throws: ValidatorError.self) {
        try svgPathKit.createCGPath()
    }
}

@Test("Create CGPath with multiple subpaths")
func testCreateCGPathMultipleSubpaths() async throws {
    let pathString = "M 10 10 L 20 20 Z M 30 30 L 40 40"
    let svgPathKit = SVGPathKit(path: pathString)
    let path = try svgPathKit.createCGPath()
    
    #expect(path.isEmpty == false)
}

@Test("Create CGPath with arc commands")
func testCreateCGPathWithArcs() async throws {
    let pathString = "M 10 10 A 5 5 0 0 1 20 20 Z"
    let svgPathKit = SVGPathKit(path: pathString)
    let path = try svgPathKit.createCGPath()
    
    #expect(path.isEmpty == false)
}

@Test("Update path string and create new CGPath")
func testUpdatePathString() async throws {
    let svgPathKit = SVGPathKit(path: "M 10 10 L 20 20")
    svgPathKit.pathString = "M 0 0 L 10 10 Z"
    let path = try svgPathKit.createCGPath()
    
    #expect(path.isEmpty == false)
}
