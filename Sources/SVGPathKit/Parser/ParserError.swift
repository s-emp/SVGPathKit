import Foundation

/// Errors that can occur during SVG path parsing.
enum ParserError: Equatable, Error {
    /// An invalid token was encountered during parsing.
    case invalidToken(Token)
    /// A command was found with insufficient arguments.
    case insufficientArguments
    /// A command was found with unexpected or extra arguments.
    case unexpectedArguments
}

// MARK: - LocalizedError Conformance

extension ParserError: LocalizedError {
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        switch self {
        case .invalidToken(let token):
            return NSLocalizedString("Invalid token '\(token)' encountered while parsing SVG path", 
                                    comment: "ParserError.invalidToken description")
        case .insufficientArguments:
            return NSLocalizedString("Insufficient arguments provided for SVG path command", 
                                    comment: "ParserError.insufficientArguments description")
        case .unexpectedArguments:
            return NSLocalizedString("Unexpected or extra arguments found for SVG path command", 
                                    comment: "ParserError.unexpectedArguments description")
        }
    }
    
    /// A localized message describing the reason for the failure.
    var failureReason: String? {
        switch self {
        case .invalidToken:
            return NSLocalizedString("The parser encountered a token that cannot be processed in the current context", 
                                    comment: "ParserError.invalidToken failure reason")
        case .insufficientArguments:
            return NSLocalizedString("An SVG path command requires more arguments than were provided", 
                                    comment: "ParserError.insufficientArguments failure reason")
        case .unexpectedArguments:
            return NSLocalizedString("An SVG path command received more arguments than expected", 
                                    comment: "ParserError.unexpectedArguments failure reason")
        }
    }
    
    /// A localized message providing recovery suggestion.
    var recoverySuggestion: String? {
        switch self {
        case .invalidToken:
            return NSLocalizedString("Ensure the SVG path data follows the correct syntax with proper command letters and numeric arguments", 
                                    comment: "ParserError.invalidToken recovery suggestion")
        case .insufficientArguments:
            return NSLocalizedString("Check that each path command has the required number of arguments (e.g., 'L' needs x,y coordinates)", 
                                    comment: "ParserError.insufficientArguments recovery suggestion")
        case .unexpectedArguments:
            return NSLocalizedString("Remove extra arguments or check that commands like 'Z' do not have any arguments", 
                                    comment: "ParserError.unexpectedArguments recovery suggestion")
        }
    }
}
