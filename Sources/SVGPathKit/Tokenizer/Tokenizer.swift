import Foundation

protocol Tokenizer {
    func tokenize(_ pathString: String) throws(TokenError) -> [Token]
}

final class Tokenize: Tokenizer {
    
    // MARK: - Main tokenization methods
    func tokenize(_ pathString: String) throws(TokenError) -> [Token] {
        var iterator = pathString.utf8.makeIterator()
        var tokens = [Token]()
        var currentSymbol: UTF8.CodeUnit? = iterator.next()
        
        while let symbol = currentSymbol {
            switch true {
            case isNumberStart(symbol):
                let number = try parseNumber(
                    currentSymbol: &currentSymbol,
                    iterator: &iterator
                )
                tokens.append(.number(number))
                
            case isCommandLetter(symbol):
                tokens.append(.command(symbol))
                currentSymbol = iterator.next()
                
            case isWhitespace(symbol):
                currentSymbol = iterator.next()
                
            default:
                throw TokenError.unknownToken
            }
        }
        
        return tokens
    }

    // MARK: - Number parsing
    private func parseNumber(
        currentSymbol: inout UTF8.CodeUnit?,
        iterator: inout IndexingIterator<String.UTF8View>
    ) throws(TokenError) -> Double {
        guard let firstSymbol = currentSymbol else {
            throw TokenError.invalidNumber
        }
        
        var numberString = ""
        var hasDigits = false
        var symbol: UTF8.CodeUnit? = firstSymbol
        
        // Parse sign
        if isSign(firstSymbol) {
            numberString.append(Character(UnicodeScalar(firstSymbol)))
            symbol = iterator.next()
        }
        
        // Parse integer part
        if let currentByte = symbol {
            symbol = try parseDigits(
                symbol: currentByte,
                iterator: &iterator,
                numberString: &numberString,
                hasDigits: &hasDigits
            )
        }
        
        // Parse decimal part
        if let currentByte = symbol, currentByte == Constants.decimalPoint {
            numberString.append(".")
            symbol = iterator.next()
            
            if let currentByte = symbol {
                symbol = try parseDigits(
                    symbol: currentByte,
                    iterator: &iterator,
                    numberString: &numberString,
                    hasDigits: &hasDigits
                )
            }
        }
        
        guard hasDigits else {
            throw TokenError.invalidNumber
        }
        
        // Parse exponent
        if let currentByte = symbol, isExponentLetter(currentByte) {
            symbol = try parseExponent(
                symbol: currentByte,
                iterator: &iterator,
                numberString: &numberString
            )
        }
        
        currentSymbol = symbol
        return try convertToDouble(numberString)
    }

    // MARK: - Helper parsing methods
    private func parseDigits(
        symbol: UTF8.CodeUnit,
        iterator: inout IndexingIterator<String.UTF8View>,
        numberString: inout String,
        hasDigits: inout Bool
    ) throws(TokenError) -> UTF8.CodeUnit? {
        var currentSymbol: UTF8.CodeUnit? = symbol
        
        while let symbol = currentSymbol, isDigit(symbol) {
            hasDigits = true
            numberString.append(Character(UnicodeScalar(symbol)))
            currentSymbol = iterator.next()
        }
        
        return currentSymbol
    }

    private func parseExponent(
        symbol: UTF8.CodeUnit,
        iterator: inout IndexingIterator<String.UTF8View>,
        numberString: inout String
    ) throws(TokenError) -> UTF8.CodeUnit? {
        numberString.append(Character(UnicodeScalar(symbol)))
        
        guard let nextSymbol = iterator.next() else {
            return nil
        }
        
        var currentSymbol: UTF8.CodeUnit? = nextSymbol
        
        // Parse optional sign after exponent
        if let symbol = currentSymbol, isSign(symbol) {
            numberString.append(Character(UnicodeScalar(symbol)))
            currentSymbol = iterator.next()
        }
        
        // Parse exponent digits
        while let symbol = currentSymbol, isDigit(symbol) {
            numberString.append(Character(UnicodeScalar(symbol)))
            currentSymbol = iterator.next()
        }
        
        return currentSymbol
    }

    // MARK: - Utility methods
    private func convertToDouble(_ numberString: String) throws(TokenError) -> Double {
        guard let number = Double(numberString) else {
            throw TokenError.invalidNumber
        }
        return number
    }

    // MARK: - Character classification methods
    private func isCommandLetter(_ byte: UTF8.CodeUnit) -> Bool {
        Int(byte) < SVGPathKit.svgPathCommands.count && SVGPathKit.svgPathCommands[Int(byte)]
    }

    private func isNumberStart(_ byte: UTF8.CodeUnit) -> Bool {
        Int(byte) < SVGPathKit.svgNumberStartChars.count && SVGPathKit.svgNumberStartChars[Int(byte)]
    }

    private func isDigit(_ byte: UTF8.CodeUnit) -> Bool {
        Int(byte) < SVGPathKit.digitChars.count && SVGPathKit.digitChars[Int(byte)]
    }

    private func isWhitespace(_ byte: UTF8.CodeUnit) -> Bool {
        Int(byte) < SVGPathKit.whitespace.count && SVGPathKit.whitespace[Int(byte)]
    }

    private func isSign(_ byte: UTF8.CodeUnit) -> Bool {
        byte == Constants.plusSign || byte == Constants.minusSign
    }

    private func isExponentLetter(_ byte: UTF8.CodeUnit) -> Bool {
        byte == Constants.lowercaseE || byte == Constants.uppercaseE
    }

    // MARK: - Constants
    private enum Constants {
        static let plusSign: UTF8.CodeUnit = 43      // +
        static let minusSign: UTF8.CodeUnit = 45     // -
        static let decimalPoint: UTF8.CodeUnit = 46  // .
        static let lowercaseE: UTF8.CodeUnit = 101   // e
        static let uppercaseE: UTF8.CodeUnit = 69    // E
    }
}
