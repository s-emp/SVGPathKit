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
        var previousCommand: Command?
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
            case .smoothCurveTo:
                guard let prev = previousCommand,
                      case .curveTo = prev else {
                    throw ValidatorError.smoothCurveWithoutPreviousCurve
                }
                
            case .smoothQuadraticCurveTo:
                guard let prev = previousCommand,
                      case .quadraticCurveTo = prev else {
                    throw ValidatorError.smoothQuadraticWithoutPreviousQuadratic
                }
                
            case .closePath:
                if index < commands.count - 1 {
                    expectingMoveToAfterClosePath = true
                }
                
            default:
                break
            }
            
            previousCommand = command
        }
    }
}
