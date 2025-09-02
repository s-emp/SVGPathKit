enum ParserError: Equatable, Error {
    case invalidToken(Token)
    case insufficientArguments
    case unexpectedArguments
}
