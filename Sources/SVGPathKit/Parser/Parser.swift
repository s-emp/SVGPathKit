protocol Parsing {
    func parse(_ tokens: [Token]) throws -> [Command]
}

final class Parser: Parsing {
    func parse(_ tokens: [Token]) throws -> [Command] { [] }
}
