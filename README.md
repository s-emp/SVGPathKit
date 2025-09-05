# SVGPathKit

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-lightgrey.svg)](https://github.com/s-emp/SVGPathKit)

A high-performance Swift library for parsing and rendering SVG path data into CoreGraphics paths. SVGPathKit provides a complete solution for processing SVG path strings and converting them into `CGPath` objects that can be used with UIKit, AppKit, and CoreGraphics.

## Features

✅ **Complete SVG 2.0 Support** - All path commands including complex elliptical arcs

✅ **High Performance** - Optimized tokenizer and parser with minimal memory allocation

✅ **Comprehensive Error Handling** - Detailed error messages with localization support

✅ **Type Safety** - Strongly typed command system with full Swift error handling

✅ **Cross-Platform** - Works on iOS, macOS, tvOS, and watchOS

✅ **Extensive Testing** - 100% test coverage with comprehensive validation

✅ **DocC Documentation** - Complete API documentation with examples

### Supported SVG Path Commands

| Command | Description | Example |
|---------|-------------|---------|
| **M, m** | Move to | `M 10 10` / `m 5 5` |
| **L, l** | Line to | `L 20 20` / `l 10 10` |
| **H, h** | Horizontal line to | `H 50` / `h 20` |
| **V, v** | Vertical line to | `V 50` / `v 20` |
| **C, c** | Cubic Bézier curve | `C 10 20 30 40 50 60` |
| **S, s** | Smooth cubic Bézier | `S 30 40 50 60` |
| **Q, q** | Quadratic Bézier curve | `Q 15 25 20 30` |
| **T, t** | Smooth quadratic Bézier | `T 30 40` |
| **A, a** | Elliptical arc | `A 25 25 0 1 0 50 25` |
| **Z, z** | Close path | `Z` |

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/s-emp/SVGPathKit.git", from: "1.0.0")
]
```

Or add it through Xcode: **File** → **Add Package Dependencies** → Enter URL

### Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 15.0+

## Quick Start

```swift
import SVGPathKit

// Create an SVGPathKit instance
let pathKit = SVGPathKit(path: "M 10 10 L 50 10 L 30 50 Z")

// Convert to CGPath
do {
    let cgPath = try pathKit.createCGPath()

    // Use with UIKit/AppKit
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = cgPath
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## Usage Examples

### Basic Shapes

```swift
// Rectangle
let rect = SVGPathKit(path: "M 0 0 H 100 V 50 H 0 Z")

// Circle (approximated with Bézier curves)
let circle = SVGPathKit(path: "M 50 0 A 50 50 0 1 1 50 100 A 50 50 0 1 1 50 0")

// Triangle
let triangle = SVGPathKit(path: "M 50 0 L 100 100 L 0 100 Z")
```

### Complex Paths

```swift
// Heart shape
let heart = SVGPathKit(path: """
    M 50,25
    C 50,15 40,5 25,5
    C 10,5 0,15 0,25
    C 0,35 10,45 25,55
    L 50,80
    L 75,55
    C 90,45 100,35 100,25
    C 100,15 90,5 75,5
    C 60,5 50,15 50,25 Z
""")

// 5-pointed star
let star = SVGPathKit(path: """
    M 50,0
    L 61,35
    L 98,35
    L 68,57
    L 79,91
    L 50,70
    L 21,91
    L 32,57
    L 2,35
    L 39,35 Z
""")
```

### Error Handling

```swift
let pathKit = SVGPathKit(path: "invalid path data")

do {
    let cgPath = try pathKit.createCGPath()
} catch let error as TokenError {
    print("Tokenization error: \(error.localizedDescription)")
} catch let error as ParserError {
    print("Parsing error: \(error.localizedDescription)")
} catch let error as ValidatorError {
    print("Validation error: \(error.localizedDescription)")
} catch {
    print("Unknown error: \(error)")
}
```

### Dynamic Path Updates

```swift
let pathKit = SVGPathKit(path: "M 0 0")

// Update the path dynamically
pathKit.pathString = "M 10 10 L 50 50 Q 75 25 100 50"

// Generate new CGPath
let updatedPath = try pathKit.createCGPath()
```

## Architecture

SVGPathKit uses a clean 4-stage pipeline:

1. **Tokenization** - Converts the path string into tokens
2. **Parsing** - Transforms tokens into structured commands
3. **Validation** - Ensures commands follow SVG 2.0 specification
4. **Rendering** - Converts commands to CoreGraphics path operations

```
"M 10 10 L 20 20" → [Token] → [Command] → Validation → CGPath
```

Each stage is independently testable and can throw specific errors for precise debugging.

## API Documentation

### Core Classes

- **`SVGPathKit`** - Main class for processing SVG paths
- **`Command`** - Represents individual SVG path commands
- **`Token`** - Represents tokenized elements from the path string

### Error Types

- **`TokenError`** - Tokenization failures (unknown tokens, invalid numbers)
- **`ParserError`** - Parsing failures (invalid syntax, insufficient arguments)
- **`ValidatorError`** - Validation failures (invalid command sequences)

All errors conform to `LocalizedError` for user-friendly error messages.

## Performance

SVGPathKit is optimized for performance:

- **Zero-copy tokenization** where possible
- **Minimal memory allocations** during parsing
- **Efficient arc-to-Bézier conversion** using mathematical optimization
- **Lookup tables** for fast character classification

Typical performance for a complex path with 100+ commands: **< 1ms** on modern devices.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Run tests with **⌘+U**
4. Build documentation with **⌘+Control+Shift+D**

### Testing

Run the full test suite:

```bash
swift test
```

For verbose output:
```bash
swift test --verbose
```

## License

SVGPathKit is released under the MIT License. See [LICENSE](LICENSE) for details.

## Credits

Created with ❤️ for the Swift community.

- Arc rendering algorithm based on [research by Mortoray](https://mortoray.com/rendering-an-svg-elliptical-arc-as-bezier-curves/)
- SVG 2.0 specification compliance
- Mathematical foundations from L. Maisonobe's elliptical arc papers

---
