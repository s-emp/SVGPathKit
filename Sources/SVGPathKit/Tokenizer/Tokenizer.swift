import Foundation

protocol Tokenizer {
    func tokenize(_ input: String) -> [Token]
}

final class Tokenize: Tokenizer {
    func tokenize(_ input: String) -> [Token] {
        []
    }
}
