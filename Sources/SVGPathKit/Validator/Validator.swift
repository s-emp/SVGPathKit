protocol Validating {
    func validate(_ commands: [Command]) throws
}

final class Validator: Validating {
    func validate(_ commands: [Command]) throws {
        guard !commands.isEmpty else {
            throw ValidatorError.emptyPath
        }
        
        guard case .moveTo = commands.first else {
            throw ValidatorError.notFoundMoveTo
        }
        
        try validateCommandSequence(commands)
    }
    
    private func validateCommandSequence(_ commands: [Command]) throws {
        var expectingMoveToAfterClosePath = false
        
        for (index, command) in commands.enumerated() {
            if expectingMoveToAfterClosePath {
                if case .moveTo = command {
                    expectingMoveToAfterClosePath = false
                } else {
                    throw ValidatorError.invalidCommandAfterClosePath
                }
            }
            
            switch command {
            case .closePath:
                if index < commands.count - 1 {
                    expectingMoveToAfterClosePath = true
                }
                
            default:
                break
            }
        }
    }
}
