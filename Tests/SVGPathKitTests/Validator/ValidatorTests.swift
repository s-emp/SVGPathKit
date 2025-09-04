import Testing
@testable import SVGPathKit

@Test(
    "Validate return success",
    arguments: [
        // Valid path with closePath followed by moveTo
        [
            Command.moveTo(x: 10, y: 20, relative: false),
            Command.lineTo(x: 30, y: 40, relative: false),
            Command.closePath,
            Command.moveTo(x: 50, y: 60, relative: false),
            Command.lineTo(x: 70, y: 80, relative: false)
        ],
        // Valid path with all command types
        [
            Command.moveTo(x: 0, y: 0, relative: false),
            Command.lineTo(x: 10, y: 10, relative: false),
            Command.horizontalLineTo(x: 20, relative: false),
            Command.verticalLineTo(y: 20, relative: false),
            Command.curveTo(x1: 25, y1: 25, x2: 30, y2: 30, x: 35, y: 35, relative: false),
            Command.smoothCurveTo(x2: 40, y2: 40, x: 45, y: 45, relative: false),
            Command.quadraticCurveTo(x1: 50, y1: 50, x: 55, y: 55, relative: false),
            Command.smoothQuadraticCurveTo(x: 60, y: 60, relative: false),
            Command.arcTo(rx: 5, ry: 5, rotation: 0, largeArc: false, sweep: true, x: 65, y: 65, relative: false),
            Command.closePath
        ],
        [
            Command.moveTo(x: 0, y: 0, relative: false),
            Command.smoothQuadraticCurveTo(x: 10, y: 10, relative: false),
            Command.quadraticCurveTo(x1: 15, y1: 15, x: 20, y: 20, relative: false),
        ],
        // Valid smooth commands without previous curves (should work per SVG standard)
        [
            Command.moveTo(x: 10, y: 20, relative: false),
            Command.smoothCurveTo(x2: 30, y2: 40, x: 50, y: 60, relative: false)
        ],
        [
            Command.moveTo(x: 10, y: 20, relative: false),
            Command.smoothQuadraticCurveTo(x: 50, y: 60, relative: false)
        ]
    ]
)
func testValidate(_ commands: [Command]) async throws {
    let validator = Validator()
    #expect(throws: Never.self, performing: {
        try validator.validate(commands)
    })
}

@Test(
    "Validate throw errors",
    arguments: [
        // Path must start with MoveTo command
        (
            [Command.lineTo(x: 10, y: 20, relative: false)],
            ValidatorError.notFoundMoveTo
        ),
        // Empty path error
        (
            [],
            ValidatorError.emptyPath
        ),
        
        // Invalid command after ClosePath (must be MoveTo)
        (
            [
                Command.moveTo(x: 10, y: 20, relative: false),
                Command.lineTo(x: 30, y: 40, relative: false),
                Command.closePath,
                Command.lineTo(x: 50, y: 60, relative: false)
            ],
            ValidatorError.invalidCommandAfterClosePath
        ),
    ]
)
func testValidateThrowErrors(_ commands: [Command], _ error: ValidatorError) async throws {
    let validator = Validator()
    #expect(throws: ValidatorError.self) {
        try validator.validate(commands)
    }
}
