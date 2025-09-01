enum Token: Equatable {
    case command(UTF8.CodeUnit)
    case number(Double)
}
