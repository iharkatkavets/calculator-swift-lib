import Testing

@testable import MathTree

struct ScannerScanTokensTests {
    func scanTokens(_ input: String) throws(ScanError) -> [Token] {
        return try Scanner(input).scanTokens()
    }

    @Test func scanWrongCharacter() {
        #expect(throws: ScanError.self) {
            _ = try scanTokens("}")
        }
    }

    @Test func scanEOFToken() throws {
        let tokens = try scanTokens("")

        #expect(tokens.count == 1)
        #expect(tokens[0].type == TokenType.EOF)
        #expect(tokens[0].lexeme == "")
        #expect(tokens[0].position == 0)
    }

    @Test func scanLeftParen() throws {
        let tokens = try scanTokens("(")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.leftParen)
        #expect(tokens[0].lexeme == "(")
        #expect(tokens[0].position == 0)
    }

    @Test func scanRightParen() throws {
        let tokens = try scanTokens(")")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.rightParen)
        #expect(tokens[0].lexeme == ")")
        #expect(tokens[0].position == 0)
    }

    @Test func scanDot() throws {
        let tokens = try scanTokens(".")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.dot)
        #expect(tokens[0].lexeme == ".")
        #expect(tokens[0].position == 0)
    }

    @Test func scanStar() throws {
        let tokens = try scanTokens("*")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.star)
        #expect(tokens[0].lexeme == "*")
        #expect(tokens[0].position == 0)
    }

    @Test func scanPlus() throws {
        let tokens = try scanTokens("+")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.plus)
        #expect(tokens[0].lexeme == "+")
        #expect(tokens[0].position == 0)
    }

    @Test func scanMinus() throws {
        let tokens = try scanTokens("-")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.minus)
        #expect(tokens[0].lexeme == "-")
        #expect(tokens[0].position == 0)
    }

    @Test func scanSlash() throws {
        let tokens = try scanTokens("/")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.slash)
        #expect(tokens[0].lexeme == "/")
        #expect(tokens[0].position == 0)
    }

    @Test func scanIntNumber() throws {
        let tokens = try scanTokens("79732")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.number(79732))
        #expect(tokens[0].lexeme == "79732")
        #expect(tokens[0].position == 0)
    }

    @Test func scanSinIdentifier() throws {
        let tokens = try scanTokens("sin")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.sin)
        #expect(tokens[0].lexeme == "sin")
        #expect(tokens[0].position == 0)
    }

    @Test func scanCosIdentifier() throws {
        let tokens = try scanTokens("cos")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.cos)
        #expect(tokens[0].lexeme == "cos")
        #expect(tokens[0].position == 0)
    }

    @Test func scanTgIdentifier() throws {
        let tokens = try scanTokens("tg")

        #expect(tokens.count == 2)
        #expect(tokens[0].type == TokenType.tg)
        #expect(tokens[0].lexeme == "tg")
        #expect(tokens[0].position == 0)
    }
}
