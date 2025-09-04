import Foundation

/// Errors that can occur during SVG path validation.
enum ValidatorError: Error {
    /// The path does not start with a MoveTo command as required by SVG specification.
    case notFoundMoveTo
    /// The path contains no commands.
    case emptyPath
    /// An argument has an invalid type for the given command.
    case invalidArgumentType
    /// An invalid command appears after a ClosePath command.
    case invalidCommandAfterClosePath
}

// MARK: - LocalizedError Conformance

extension ValidatorError: LocalizedError {
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        switch self {
        case .notFoundMoveTo:
            return NSLocalizedString("SVG path must start with MoveTo command", 
                                    comment: "ValidatorError.notFoundMoveTo description")
        case .emptyPath:
            return NSLocalizedString("SVG path is empty", 
                                    comment: "ValidatorError.emptyPath description")
        case .invalidArgumentType:
            return NSLocalizedString("Invalid argument type for SVG path command", 
                                    comment: "ValidatorError.invalidArgumentType description")
        case .invalidCommandAfterClosePath:
            return NSLocalizedString("Invalid command following ClosePath in SVG path", 
                                    comment: "ValidatorError.invalidCommandAfterClosePath description")
        }
    }
    
    /// A localized message describing the reason for the failure.
    var failureReason: String? {
        switch self {
        case .notFoundMoveTo:
            return NSLocalizedString("SVG paths must begin with a MoveTo (M or m) command to establish the initial position", 
                                    comment: "ValidatorError.notFoundMoveTo failure reason")
        case .emptyPath:
            return NSLocalizedString("The path contains no drawing commands", 
                                    comment: "ValidatorError.emptyPath failure reason")
        case .invalidArgumentType:
            return NSLocalizedString("A command received an argument of the wrong type or format", 
                                    comment: "ValidatorError.invalidArgumentType failure reason")
        case .invalidCommandAfterClosePath:
            return NSLocalizedString("After a ClosePath (Z or z) command, only MoveTo commands are allowed", 
                                    comment: "ValidatorError.invalidCommandAfterClosePath failure reason")
        }
    }
    
    /// A localized message providing recovery suggestion.
    var recoverySuggestion: String? {
        switch self {
        case .notFoundMoveTo:
            return NSLocalizedString("Start your SVG path with a MoveTo command, such as 'M 10 20' or 'm 10 20'", 
                                    comment: "ValidatorError.notFoundMoveTo recovery suggestion")
        case .emptyPath:
            return NSLocalizedString("Add at least one MoveTo command to create a valid SVG path", 
                                    comment: "ValidatorError.emptyPath recovery suggestion")
        case .invalidArgumentType:
            return NSLocalizedString("Check that all command arguments are properly formatted numbers", 
                                    comment: "ValidatorError.invalidArgumentType recovery suggestion")
        case .invalidCommandAfterClosePath:
            return NSLocalizedString("After a ClosePath command, use MoveTo (M or m) to start a new subpath", 
                                    comment: "ValidatorError.invalidCommandAfterClosePath recovery suggestion")
        }
    }
}
