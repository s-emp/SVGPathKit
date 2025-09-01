import Foundation

protocol Tokenizer {
    func tokenize(_ pathString: String) throws(TokenError) -> [Token]
}

final class Tokenize: Tokenizer {
    

    func tokenize(_ pathString: String) throws(TokenError) -> [Token] {
        var iterator = pathString.utf8.makeIterator()
        var tokens = [Token]()
        var isNeedNextSymbol: Bool = true
        var currentSymbol: UTF8.CodeUnit?
        while true {
            if isNeedNextSymbol { currentSymbol = iterator.next() }
            guard currentSymbol != nil else { break }
            if isNumberStart(Int(currentSymbol!)) {
                let number = try tokenizeNumber(
                    currentSymbol: &currentSymbol,
                    iterator: &iterator
                )
                tokens.append(.number(number))
                isNeedNextSymbol = false
            } else if isCommandLetter(Int(currentSymbol!)) {
                tokens.append(.command(currentSymbol!))
                isNeedNextSymbol = true
            } else if isWhitespace(Int(currentSymbol!)) {
                isNeedNextSymbol = true
            } else {
                throw .unknownToken
            }
        }
        return tokens
    }

    func tokenizeNumber(
        currentSymbol: inout UTF8.CodeUnit?,
        iterator: inout IndexingIterator<String.UTF8View>
    ) throws(TokenError) -> Double {
        guard var localCurrentSymbol = currentSymbol else {
            throw TokenError.invalidNumber
        }
        var numberString = ""
        var hasDigits = false

        if localCurrentSymbol == 43 || localCurrentSymbol == 45 {  // + or -
            numberString.append(Character(UnicodeScalar(localCurrentSymbol)))
            guard let next = iterator.next() else {
                guard let number = Double(numberString) else {
                    throw TokenError.invalidNumber
                }
                currentSymbol = nil
                return number
            }
            localCurrentSymbol = next
        }

        while isDigit(Int(localCurrentSymbol)) {
            hasDigits = true
            numberString.append(Character(UnicodeScalar(localCurrentSymbol)))
            guard let next = iterator.next() else {
                guard let number = Double(numberString) else {
                    throw TokenError.invalidNumber
                }
                currentSymbol = nil
                return number
            }
            localCurrentSymbol = next
        }

        if localCurrentSymbol == 46 {  // .
            numberString.append(".")
            guard let next = iterator.next() else {
                guard let number = Double(numberString) else {
                    throw TokenError.invalidNumber
                }
                return number
            }
            localCurrentSymbol = next

            while isDigit(Int(localCurrentSymbol)) {
                hasDigits = true
                numberString.append(Character(UnicodeScalar(localCurrentSymbol)))
                guard let next = iterator.next() else {
                    guard let number = Double(numberString) else {
                        throw TokenError.invalidNumber
                    }
                    currentSymbol = nil
                    return number
                }
                localCurrentSymbol = next
            }
        }

        if !hasDigits {
            throw TokenError.invalidNumber
        }

        if localCurrentSymbol == 101 || localCurrentSymbol == 69 {  // e or E
            numberString.append(Character(UnicodeScalar(localCurrentSymbol)))
            guard let next = iterator.next() else {
                guard let number = Double(numberString) else {
                    throw TokenError.invalidNumber
                }
                currentSymbol = nil
                return number
            }
            localCurrentSymbol = next

            if localCurrentSymbol == 43 || localCurrentSymbol == 45 {  // + or -
                numberString.append(Character(UnicodeScalar(localCurrentSymbol)))
                guard let next = iterator.next() else {
                    guard let number = Double(numberString) else {
                        throw TokenError.invalidNumber
                    }
                    currentSymbol = nil
                    return number
                }
                localCurrentSymbol = next
            }

            while isDigit(Int(localCurrentSymbol)) {
                numberString.append(Character(UnicodeScalar(localCurrentSymbol)))
                guard let next = iterator.next() else {
                    guard let number = Double(numberString) else {
                        throw TokenError.invalidNumber
                    }
                    
                    currentSymbol = nil
                    return number
                }
                localCurrentSymbol = next
            }
        }

        guard let number = Double(numberString) else {
            throw TokenError.invalidNumber
        }
        currentSymbol = localCurrentSymbol
        return number
    }

    private func isCommandLetter(_ byte: Int) -> Bool {
        byte < SVGPathKit.svgPathCommands.count && SVGPathKit.svgPathCommands[byte]
    }

    private func isNumberStart(_ byte: Int) -> Bool {
        byte < SVGPathKit.svgNumberStartChars.count && SVGPathKit.svgNumberStartChars[byte]
    }
    
    private func isDigit(_ byte: Int) -> Bool {
        byte < SVGPathKit.digitChars.count && SVGPathKit.digitChars[byte]
    }

    private func isWhitespace(_ byte: Int) -> Bool {
        byte < SVGPathKit.whitespace.count && SVGPathKit.whitespace[byte]
    }
}
