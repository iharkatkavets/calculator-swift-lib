import Foundation

public final class Scanner {
    private let expression: [Character]
    private var tokens = [Token]()
    private var start: Position = 0
    private var current: Position = 0
    private var errors = [(Position, String)]()
    private let endMarker: Character = "\0"
    private let functions: [String: TokenType] = [
        "sin": .sin,
        "cos": .cos,
        "tg": .tg,
    ]

    private var isEndReached: Bool {
        return current >= expression.count
    }

    public init(_ expression: String) {
        self.expression = Array(expression)
    }

    public func scanTokens() throws(ScanError) -> [Token] {
        while !isEndReached {
            start = current
            try scanToken()
        }

        tokens.append(Token(.EOF, "", nil, current))

        guard errors.isEmpty else {
            throw ScanError(errors: errors)
        }
        return tokens
    }

    private func scanToken() throws(ScanError) {
        let c = advance()
        switch c {
        case "(": addToken(.leftParen)
        case ")": addToken(.rightParen)
        case ".": addToken(.dot)
        case "+": addToken(.plus)
        case "-": addToken(.minus)
        case "*": addToken(.star)
        case "/": addToken(.slash)
        case " ", "\t": break
        default:
            if isDigit(c) {
                number()
            } else if isAlpha(c) {
                function()
            } else {
                reportError("Unexpected character")
            }
        }
    }

    @discardableResult
    private func advance() -> Character {
        defer { current += 1 }
        return expression[current]
    }

    private func math(_ ch: Character) -> Bool {
        if isEndReached { return false }
        if expression[current] != ch { return false }

        defer { current += 1 }
        return true
    }

    private func addToken(_ tokenType: TokenType, _ literal: Any? = nil) {
        let lexema = String(expression[start..<current])
        tokens.append(Token(tokenType, lexema, literal, start))
    }

    private func reportError(_ message: String) {
        errors.append((start, message))
    }

    private func isDigit(_ ch: Character) -> Bool {
        guard let ascii = ch.asciiValue else { return false }

        return (0x30 <= ascii && ascii <= 0x39)
    }

    private func peek() -> Character {
        if isEndReached { return endMarker }

        return expression[current]
    }

    private func number() {
        while isDigit(peek()) {
            advance()
        }

        if peek() == "." && isDigit(peekNext()) {
            advance()

            while isDigit(peek()) {
                advance()
            }
        }

        guard let double = Double(String(expression[start..<current])) else {
            reportError("Wrong number")
            return
        }

        addToken(.number, double)
    }

    private func peekNext() -> Character {
        if current + 1 >= expression.count { return endMarker }

        return expression[current + 1]
    }

    private func isAlpha(_ ch: Character) -> Bool {
        guard let ascii = ch.asciiValue else { return false }

        return (0x41 <= ascii && ascii <= 0x5A)
            || (0x61 <= ascii && ascii <= 0x7A)
    }

    private func function() {
        while isAlphaNumeric(peek()) {
            advance()
        }

        let str = String(expression[start..<current])
        guard let type = functions[str] else {
            reportError("Wrong str")
            return
        }

        addToken(type)
    }

    private func isAlphaNumeric(_ ch: Character) -> Bool {
        return isAlpha(ch) || isDigit(ch)
    }
}
