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
