import Testing
import CoreGraphics
@testable import SVGPathKit

@Test("Render simple path")
func testRenderSimplePath() async throws {
    let commands = [
        Command.moveTo(x: 10, y: 20, relative: false),
        Command.lineTo(x: 30, y: 40, relative: false),
        Command.closePath
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
}

@Test("Render absolute commands")
func testRenderAbsoluteCommands() async throws {
    let commands = [
        Command.moveTo(x: 0, y: 0, relative: false),
        Command.lineTo(x: 10, y: 10, relative: false),
        Command.horizontalLineTo(x: 20, relative: false),
        Command.verticalLineTo(y: 30, relative: false),
        Command.closePath
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
    let boundingBox = path.boundingBox
    #expect(boundingBox.maxX >= 20)
    #expect(boundingBox.maxY >= 30)
}

@Test("Render relative commands")
func testRenderRelativeCommands() async throws {
    let commands = [
        Command.moveTo(x: 10, y: 10, relative: false),
        Command.lineTo(x: 5, y: 5, relative: true),
        Command.horizontalLineTo(x: 10, relative: true),
        Command.verticalLineTo(y: 10, relative: true)
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
}

@Test("Render cubic curves")
func testRenderCubicCurves() async throws {
    let commands = [
        Command.moveTo(x: 10, y: 10, relative: false),
        Command.curveTo(x1: 15, y1: 15, x2: 20, y2: 20, x: 30, y: 30, relative: false),
        Command.smoothCurveTo(x2: 40, y2: 40, x: 50, y: 50, relative: false)
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
}

@Test("Render quadratic curves")
func testRenderQuadraticCurves() async throws {
    let commands = [
        Command.moveTo(x: 10, y: 10, relative: false),
        Command.quadraticCurveTo(x1: 15, y1: 15, x: 20, y: 20, relative: false),
        Command.smoothQuadraticCurveTo(x: 30, y: 30, relative: false)
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
}

@Test("Render arc command placeholder")
func testRenderArcCommand() async throws {
    let commands = [
        Command.moveTo(x: 10, y: 10, relative: false),
        Command.arcTo(rx: 5, ry: 5, rotation: 0, largeArc: false, sweep: true, x: 20, y: 20, relative: false)
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
}

@Test("Render empty commands")
func testRenderEmptyCommands() async throws {
    let commands: [Command] = []
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == true)
}

@Test("Render multiple subpaths")
func testRenderMultipleSubpaths() async throws {
    let commands = [
        Command.moveTo(x: 10, y: 10, relative: false),
        Command.lineTo(x: 20, y: 20, relative: false),
        Command.closePath,
        Command.moveTo(x: 30, y: 30, relative: false),
        Command.lineTo(x: 40, y: 40, relative: false)
    ]
    
    let renderer = PathRenderer()
    let path = renderer.render(commands)
    
    #expect(path.isEmpty == false)
}
