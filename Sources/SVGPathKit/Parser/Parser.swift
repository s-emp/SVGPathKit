protocol Parsing {
    func parse(_ tokens: [Token]) throws -> [Command]
}

final class Parser: Parsing {
    func parse(_ tokens: [Token]) throws -> [Command] {
        var commands: [Command] = []
        var index = 0
        
        while index < tokens.count {
            guard case let .command(commandCode) = tokens[index] else {
                throw ParserError.invalidToken(tokens[index])
            }
            
            index += 1
            
            switch commandCode {
            case 77, 109: // 'M', 'm' - MoveTo
                try parseMoveTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 109)
                
            case 76, 108: // 'L', 'l' - LineTo
                try parseLineTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 108)
                
            case 72, 104: // 'H', 'h' - Horizontal LineTo
                try parseHorizontalLineTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 104)
                
            case 86, 118: // 'V', 'v' - Vertical LineTo
                try parseVerticalLineTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 118)
                
            case 67, 99: // 'C', 'c' - CurveTo
                try parseCurveTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 99)
                
            case 83, 115: // 'S', 's' - Smooth CurveTo
                try parseSmoothCurveTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 115)
                
            case 81, 113: // 'Q', 'q' - Quadratic CurveTo
                try parseQuadraticCurveTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 113)
                
            case 84, 116: // 'T', 't' - Smooth Quadratic CurveTo
                try parseSmoothQuadraticCurveTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 116)
                
            case 65, 97: // 'A', 'a' - ArcTo
                try parseArcTo(tokens: tokens, index: &index, commands: &commands, isRelative: commandCode == 97)
                
            case 90, 122: // 'Z', 'z' - ClosePath
                try parseClosePath(tokens: tokens, index: &index, commands: &commands)
                
            default:
                throw ParserError.invalidToken(Token.command(commandCode))
            }
        }
        
        return commands
    }
    
    private func parseMoveTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var isFirstPoint = true
        
        while index + 1 < tokens.count,
              case let .number(x) = tokens[index],
              case let .number(y) = tokens[index + 1] {
            
            if isFirstPoint {
                commands.append(.moveTo(x: x, y: y, relative: isRelative))
                isFirstPoint = false
            } else {
                commands.append(.lineTo(x: x, y: y, relative: isRelative))
            }
            
            index += 2
        }
        
        if isFirstPoint {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseLineTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index + 1 < tokens.count,
              case let .number(x) = tokens[index],
              case let .number(y) = tokens[index + 1] {
            
            commands.append(.lineTo(x: x, y: y, relative: isRelative))
            hasArguments = true
            index += 2
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseHorizontalLineTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index < tokens.count,
              case let .number(x) = tokens[index] {
            
            commands.append(.horizontalLineTo(x: x, relative: isRelative))
            hasArguments = true
            index += 1
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseVerticalLineTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index < tokens.count,
              case let .number(y) = tokens[index] {
            
            commands.append(.verticalLineTo(y: y, relative: isRelative))
            hasArguments = true
            index += 1
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseCurveTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index + 5 < tokens.count,
              case let .number(x1) = tokens[index],
              case let .number(y1) = tokens[index + 1],
              case let .number(x2) = tokens[index + 2],
              case let .number(y2) = tokens[index + 3],
              case let .number(x) = tokens[index + 4],
              case let .number(y) = tokens[index + 5] {
            
            commands.append(.curveTo(x1: x1, y1: y1, x2: x2, y2: y2, x: x, y: y, relative: isRelative))
            hasArguments = true
            index += 6
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseSmoothCurveTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index + 3 < tokens.count,
              case let .number(x2) = tokens[index],
              case let .number(y2) = tokens[index + 1],
              case let .number(x) = tokens[index + 2],
              case let .number(y) = tokens[index + 3] {
            
            commands.append(.smoothCurveTo(x2: x2, y2: y2, x: x, y: y, relative: isRelative))
            hasArguments = true
            index += 4
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseQuadraticCurveTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index + 3 < tokens.count,
              case let .number(x1) = tokens[index],
              case let .number(y1) = tokens[index + 1],
              case let .number(x) = tokens[index + 2],
              case let .number(y) = tokens[index + 3] {
            
            commands.append(.quadraticCurveTo(x1: x1, y1: y1, x: x, y: y, relative: isRelative))
            hasArguments = true
            index += 4
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseSmoothQuadraticCurveTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index + 1 < tokens.count,
              case let .number(x) = tokens[index],
              case let .number(y) = tokens[index + 1] {
            
            commands.append(.smoothQuadraticCurveTo(x: x, y: y, relative: isRelative))
            hasArguments = true
            index += 2
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseArcTo(tokens: [Token], index: inout Int, commands: inout [Command], isRelative: Bool) throws {
        var hasArguments = false
        
        while index + 6 < tokens.count,
              case let .number(rx) = tokens[index],
              case let .number(ry) = tokens[index + 1],
              case let .number(rotation) = tokens[index + 2],
              case let .number(largeArcValue) = tokens[index + 3],
              case let .number(sweepValue) = tokens[index + 4],
              case let .number(x) = tokens[index + 5],
              case let .number(y) = tokens[index + 6] {
            
            let largeArc = largeArcValue != 0
            let sweep = sweepValue != 0
            
            commands.append(.arcTo(rx: rx, ry: ry, rotation: rotation, largeArc: largeArc, sweep: sweep, x: x, y: y, relative: isRelative))
            hasArguments = true
            index += 7
        }
        
        if !hasArguments {
            throw ParserError.insufficientArguments
        }
    }
    
    private func parseClosePath(tokens: [Token], index: inout Int, commands: inout [Command]) throws {
        // Check if there are any arguments following Z/z command
        if index < tokens.count && tokens[index].isNumber {
            throw ParserError.unexpectedArguments
        }
        
        commands.append(.closePath)
    }
}
