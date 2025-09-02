enum Token: Equatable {
    case command(UTF8.CodeUnit)
    case number(Double)
    
    var isNumber: Bool {
        switch self {
        case .number:
            return true
        case .command:
            return false
        }
    }
}
