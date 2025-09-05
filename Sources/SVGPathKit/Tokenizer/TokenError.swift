import Foundation

/// Errors that can occur during SVG path tokenization.
public enum TokenError: Error {
    /// Encountered an unrecognized character in the path data.
    case unknownToken
    /// Found a malformed or invalid numeric value in the path data.
    case invalidNumber
}

// MARK: - LocalizedError Conformance

extension TokenError: LocalizedError {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .unknownToken:
            return NSLocalizedString("Unknown token encountered in SVG path data", 
                                    comment: "TokenError.unknownToken description")
        case .invalidNumber:
            return NSLocalizedString("Invalid or malformed number in SVG path data", 
                                    comment: "TokenError.invalidNumber description")
        }
    }
    
    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
        case .unknownToken:
            return NSLocalizedString("The SVG path contains an unrecognized character or symbol", 
                                    comment: "TokenError.unknownToken failure reason")
        case .invalidNumber:
            return NSLocalizedString("A numeric value in the path could not be parsed correctly", 
                                    comment: "TokenError.invalidNumber failure reason")
        }
    }
    
    /// A localized message providing recovery suggestion.
    public var recoverySuggestion: String? {
        switch self {
        case .unknownToken:
            return NSLocalizedString("Check that the SVG path data uses only valid SVG path commands and syntax", 
                                    comment: "TokenError.unknownToken recovery suggestion")
        case .invalidNumber:
            return NSLocalizedString("Verify that all numbers in the path are properly formatted (e.g., '10.5', '-3.14e2')", 
                                    comment: "TokenError.invalidNumber recovery suggestion")
        }
    }
}
