# Contributing to SVGPathKit

Thank you for your interest in contributing to SVGPathKit! This document provides guidelines and information for contributors.

## Code of Conduct

By participating in this project, you agree to abide by our code of conduct. We are committed to providing a welcoming and harassment-free experience for everyone.

## How to Contribute

### Reporting Issues

Before creating an issue, please:

1. **Search existing issues** to avoid duplicates
2. **Use the latest version** of SVGPathKit
3. **Provide detailed information** including:
   - SVG path data that caused the issue
   - Expected vs actual behavior
   - Platform and iOS/macOS version
   - Complete error messages or stack traces

### Suggesting Features

We welcome feature suggestions! Please:

1. **Check existing issues** for similar requests
2. **Explain the use case** and why it would be valuable
3. **Consider the scope** - features should align with SVG 2.0 specification
4. **Provide examples** of how the feature would be used

### Pull Requests

#### Before You Start

1. **Fork the repository** and create a feature branch
2. **Discuss major changes** in an issue first
3. **Ensure you understand** the existing architecture and patterns

#### Development Setup

1. Clone your fork:
   ```bash
   git clone https://github.com/s-emp/SVGPathKit.git
   cd SVGPathKit
   ```

2. Open the project in Xcode:
   ```bash
   open Package.swift
   ```

3. Run tests to ensure everything works:
   ```bash
   swift test
   ```

#### Making Changes

**Code Style:**
- Follow existing Swift conventions and patterns
- Use meaningful variable and function names
- Add comprehensive documentation for public APIs
- Include inline comments for complex algorithms

**Testing:**
- Add tests for all new functionality
- Ensure existing tests continue to pass
- Test edge cases and error conditions
- Include performance tests for optimization changes

**Documentation:**
- Update README.md if needed
- Add DocC comments for new public APIs
- Include usage examples in documentation

#### Commit Messages

Use clear, descriptive commit messages:

```
feat: add support for relative arc commands
fix: resolve parsing error with scientific notation
docs: update API documentation for Command enum
test: add comprehensive elliptical arc test cases
```

#### Pull Request Process

1. **Update your branch** with the latest changes from main
2. **Run all tests** and ensure they pass
3. **Check your code** builds without warnings
4. **Update documentation** as needed
5. **Create a pull request** with:
   - Clear title and description
   - Reference any related issues
   - List of changes made
   - Testing performed

## Architecture Overview

Understanding the SVGPathKit architecture will help you contribute effectively:

### Pipeline Stages

```
SVG String → Tokenizer → Parser → Validator → Renderer → CGPath
```

1. **Tokenizer** (`Sources/SVGPathKit/Tokenizer/`)
   - Breaks path strings into tokens
   - Handles numbers, commands, and whitespace
   - Uses lookup tables for performance

2. **Parser** (`Sources/SVGPathKit/Parser/`)
   - Converts tokens into structured commands
   - Validates argument counts and types
   - Handles command repetition and defaults

3. **Validator** (`Sources/SVGPathKit/Validator/`)
   - Ensures command sequences are valid per SVG spec
   - Checks for required MoveTo at start
   - Validates command order after ClosePath

4. **Renderer** (`Sources/SVGPathKit/Renderer/`)
   - Converts commands to CoreGraphics operations
   - Handles coordinate transformations
   - Implements arc-to-Bézier conversion

### Key Design Principles

- **Separation of Concerns**: Each stage has a single responsibility
- **Error Handling**: Detailed, localized error messages at each stage
- **Performance**: Optimized for speed and memory usage
- **Testability**: Each component is independently testable
- **SVG Compliance**: Strict adherence to SVG 2.0 specification

## Testing Guidelines

### Test Categories

1. **Unit Tests**: Test individual components in isolation
2. **Integration Tests**: Test the complete pipeline
3. **Performance Tests**: Measure speed and memory usage
4. **Compliance Tests**: Verify SVG specification adherence

### Test Structure

```swift
@Test("Descriptive test name")
func testSpecificBehavior() async throws {
    // Arrange
    let input = "test data"

    // Act
    let result = try component.process(input)

    // Assert
    #expect(result == expectedResult)
}
```

### Running Tests

```bash
# Run all tests
swift test

# Run specific test suite
swift test --filter TokenizerTests

# Run with verbose output
swift test --verbose
```

## Performance Considerations

When contributing, keep performance in mind:

- **Minimize allocations** in hot paths
- **Use lookup tables** for character classification
- **Avoid string manipulation** in parsing loops
- **Profile changes** with large SVG paths

## Documentation Standards

### Public API Documentation

Use DocC comments for all public APIs:

```swift
/// Brief description of the function.
///
/// Detailed explanation of the function's behavior,
/// including any important notes or considerations.
///
/// - Parameter param: Description of the parameter
/// - Returns: Description of the return value
/// - Throws: Description of errors that may be thrown
///
/// ## Example
/// ```swift
/// let result = try function(param: "value")
/// ```
public func function(param: String) throws -> Result
```

### Code Comments

- Explain **why**, not **what**
- Document complex algorithms with references
- Include performance notes for optimizations

## Questions?

- **Check the documentation** in the README
- **Search existing issues** for similar questions
- **Open a new issue** with the "question" label
- **Join discussions** in existing issues

Thank you for contributing to SVGPathKit! 🎉
