enum ValidatorError: Error {
    case notFoundMoveTo
    case emptyPath
    case invalidArgumentType
    case invalidCommandAfterClosePath
    case smoothCurveWithoutPreviousCurve
    case smoothQuadraticWithoutPreviousQuadratic
}
