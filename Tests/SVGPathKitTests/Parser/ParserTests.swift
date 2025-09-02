import Testing
@testable import SVGPathKit

@Test(
    "parse",
    arguments: [
        // MoveTo absolute (M)
        (
            [
                Token.command(77),
                Token.number(10),
                Token.number(20),
                Token.number(30),
                Token.number(40),
                Token.number(50),
                Token.number(60),
                Token.command(90),
            ],
            [
                Command.moveTo(x: 10, y: 20, relative: false),
                Command.lineTo(x: 30, y: 40, relative: false),
                Command.lineTo(x: 50, y: 60, relative: false),
                Command.closePath,
            ]
        ),
//        // MoveTo relative (m)
        (
            [
                Token.command(109),
                Token.number(5),
                Token.number(10)
            ],
            [
                Command.moveTo(x: 5, y: 10, relative: true)
            ]
        ),
        // LineTo absolute (L)
        (
            [
                Token.command(76),
                Token.number(15),
                Token.number(25)
            ],
            [
                Command.lineTo(x: 15, y: 25, relative: false)
            ]
        ),
        // LineTo relative (l)
        (
            [
                Token.command(108),
                Token.number(5),
                Token.number(5)
            ],
            [
                Command.lineTo(x: 5, y: 5, relative: true)
            ]
        ),
        // Horizontal LineTo absolute (H)
        (
            [
                Token.command(72),
                Token.number(50)
            ],
            [
                Command.horizontalLineTo(x: 50, relative: false)
            ]
        ),
        // Horizontal LineTo relative (h)
        (
            [
                Token.command(104),
                Token.number(10)
            ],
            [
                Command.horizontalLineTo(x: 10, relative: true)
            ]
        ),
        // Vertical LineTo absolute (V)
        (
            [
                Token.command(86),
                Token.number(30)
            ],
            [
                Command.verticalLineTo(y: 30, relative: false)
            ]
        ),
        // Vertical LineTo relative (v)
        (
            [
                Token.command(118),
                Token.number(15)
            ],
            [
                Command.verticalLineTo(y: 15, relative: true)
            ]
        ),
        // CurveTo absolute (C)
        (
            [
                Token.command(67),
                Token.number(10), Token.number(20),
                Token.number(30), Token.number(40),
                Token.number(50), Token.number(60)
            ],
            [
                Command.curveTo(x1: 10, y1: 20, x2: 30, y2: 40, x: 50, y: 60, relative: false)
            ]
        ),
        // CurveTo relative (c)
        (
            [
                Token.command(99),
                Token.number(5), Token.number(5),
                Token.number(10), Token.number(10),
                Token.number(15), Token.number(15)
            ],
            [
                Command.curveTo(x1: 5, y1: 5, x2: 10, y2: 10, x: 15, y: 15, relative: true)
            ]
        ),
        // Smooth CurveTo absolute (S)
        (
            [
                Token.command(83),
                Token.number(20), Token.number(30),
                Token.number(40), Token.number(50)
            ],
            [
                Command.smoothCurveTo(x2: 20, y2: 30, x: 40, y: 50, relative: false)
            ]
        ),
        // Smooth CurveTo relative (s)
        (
            [
                Token.command(115),
                Token.number(10), Token.number(10),
                Token.number(20), Token.number(20)
            ],
            [
                Command.smoothCurveTo(x2: 10, y2: 10, x: 20, y: 20, relative: true)
            ]
        ),
        // Quadratic CurveTo absolute (Q)
        (
            [
                Token.command(81),
                Token.number(15), Token.number(25),
                Token.number(35), Token.number(45)
            ],
            [
                Command.quadraticCurveTo(x1: 15, y1: 25, x: 35, y: 45, relative: false)
            ]
        ),
        // Quadratic CurveTo relative (q)
        (
            [
                Token.command(113),
                Token.number(5), Token.number(10),
                Token.number(15), Token.number(20)
            ],
            [
                Command.quadraticCurveTo(x1: 5, y1: 10, x: 15, y: 20, relative: true)
            ]
        ),
        // Smooth Quadratic CurveTo absolute (T)
        (
            [
                Token.command(84),
                Token.number(25),
                Token.number(35)
            ],
            [
                Command.smoothQuadraticCurveTo(x: 25, y: 35, relative: false)
            ]
        ),
        // Smooth Quadratic CurveTo relative (t)
        (
            [
                Token.command(116),
                Token.number(10),
                Token.number(15)
            ],
            [
                Command.smoothQuadraticCurveTo(x: 10, y: 15, relative: true)
            ]
        ),
        // ArcTo absolute (A)
        (
            [
                Token.command(65),
                Token.number(25), Token.number(25),
                Token.number(0),
                Token.number(1), Token.number(0),
                Token.number(50), Token.number(25)
            ],
            [
                Command.arcTo(rx: 25, ry: 25, rotation: 0, largeArc: true, sweep: false, x: 50, y: 25, relative: false)
            ]
        ),
        // ArcTo relative (a)
        (
            [
                Token.command(97),
                Token.number(10), Token.number(15),
                Token.number(45),
                Token.number(0), Token.number(1),
                Token.number(20), Token.number(30)
            ],
            [
                Command.arcTo(rx: 10, ry: 15, rotation: 45, largeArc: false, sweep: true, x: 20, y: 30, relative: true)
            ]
        ),
        // ClosePath (Z)
        (
            [
                Token.command(90)
            ],
            [
                Command.closePath
            ]
        ),
        // ClosePath (z)
        (
            [
                Token.command(122)
            ],
            [
                Command.closePath
            ]
        )
    ]
)
func testParse(_ input: [Token], _ expected: [Command]) async throws {
    let parser = Parser()
    #expect(try parser.parse(input) == expected)
}

@Test(
    "parse error for insufficient arguments",
    arguments: [
        // MoveTo (M) with insufficient arguments - needs 2, given 1
        [
            Token.command(77),
            Token.number(10),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // LineTo (L) with insufficient arguments - needs 2, given 1
        [
            Token.command(76),
            Token.number(15),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // Horizontal LineTo (H) with insufficient arguments - needs 1, given 0
        [
            Token.command(72),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // Vertical LineTo (V) with insufficient arguments - needs 1, given 0
        [
            Token.command(86),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // CurveTo (C) with insufficient arguments - needs 6, given 5
        [
            Token.command(67),
            Token.number(10), Token.number(20),
            Token.number(30), Token.number(40),
            Token.number(50),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // Smooth CurveTo (S) with insufficient arguments - needs 4, given 3
        [
            Token.command(83),
            Token.number(20), Token.number(30),
            Token.number(40),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // Quadratic CurveTo (Q) with insufficient arguments - needs 4, given 3
        [
            Token.command(81),
            Token.number(15), Token.number(25),
            Token.number(35),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // Smooth Quadratic CurveTo (T) with insufficient arguments - needs 2, given 1
        [
            Token.command(84),
            Token.number(25),
            Token.command(76), Token.number(10), Token.number(10)
        ],
        // ArcTo (A) with insufficient arguments - needs 7, given 6
        [
            Token.command(65),
            Token.number(25), Token.number(25),
            Token.number(0),
            Token.number(1), Token.number(0),
            Token.number(50),
            Token.command(76), Token.number(10), Token.number(10)
        ]
    ]
)
func testParseInsufficientArguments(_ input: [Token]) async throws {
    let parser = Parser()
    #expect(throws: ParserError.insufficientArguments) {
        try parser.parse(input)
    }
}

@Test("parse error for Z command with arguments")
func testParseClosePathWithArguments() async throws {
    let input = [
        Token.command(77), Token.number(10), Token.number(20), // M 10 20
        Token.command(76), Token.number(10), Token.number(10), // L 10 10
        Token.command(90), Token.number(10), Token.number(20), // Z 10 20
        Token.command(76), Token.number(10), Token.number(10)  // L 10 10
    ]
    let parser = Parser()
    #expect(throws: ParserError.unexpectedArguments) {
        try parser.parse(input)
    }
}

@Test("parse error for command starting with number token")
func testParseStartNumbersArguments() async throws {
    let input = [
        Token.number(10), Token.number(20), // 10 20
    ]
    let parser = Parser()
    #expect(throws: ParserError.invalidToken(Token.number(10))) {
        try parser.parse(input)
    }
}

