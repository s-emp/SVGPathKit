protocol Validating {
    func validate(_ commands: [Command]) throws
}

final class Validate: Validating {
    func validate(_ commands: [Command]) throws {
        ()
    }
}
