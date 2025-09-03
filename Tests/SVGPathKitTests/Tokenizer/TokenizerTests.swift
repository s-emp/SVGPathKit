import Testing

@testable import SVGPathKit

@Test(
    arguments: [
        ("Mm Zz", [Token.command(77), Token.command(109), Token.command(90), Token.command(122)]),
        ("M 10,20", [Token.command(77), Token.number(10), Token.number(20)]),
    ]
)
func testTokenizerCommands(input: String, expected: [Token]) async throws {
    let tokenizer = Tokenize()
    let result = try tokenizer.tokenize(input)
    #expect(result == expected)
}

@Test(
    arguments: [
        ("  \t\n\r  ", []),
        ("  M  10  ", [Token.command(77), Token.number(10)]),
        ("\tL\n20\r", [Token.command(76), Token.number(20)]),
    ]
)
func testTokenizerWhitespace(input: String, expected: [Token]) async throws {
    let tokenizer = Tokenize()
    let result = try tokenizer.tokenize(input)
    #expect(result == expected)
}

@Test(
    arguments: [
        ("-.5", [Token.number(-0.5)]),
        (".5", [Token.number(0.5)]),
        ("5. +.5", [Token.number(5), Token.number(0.5)]),
        ("0.5.5", [Token.number(0.5), Token.number(0.5)]),
        ("00015", [Token.number(15)]),
        ("10-20", [Token.number(10), Token.number(-20)]),
        ("+123", [Token.number(123)]),
        ("1e5", [Token.number(100000)]),
        ("1E5", [Token.number(100000)]),
        ("2E-3", [Token.number(0.002)]),
        ("-3.14e+2", [Token.number(-314)]),
    ]
)
func testTokenizerSVGNumbers(input: String, expected: [Token]) async throws {
    let tokenizer = Tokenize()
    let result = try tokenizer.tokenize(input)
    #expect(result == expected)
}
