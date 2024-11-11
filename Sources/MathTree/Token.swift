import Foundation

enum TokenType: Equatable {
    // Single-character tokens
    case leftParen
    case rightParen
    case comma
    case dot
    case minus
    case plus
    case slash
    case star

    // Literals
    case number

    // Functions
    // To be added here
    case sin
    case cos
    case tg
    case ctg
    case sqrt

    case EOF
}

public final class Token: CustomStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: Any?
    let position: Position

    init(_ type: TokenType, _ lexeme: String, _ literal: Any? = nil, _ position: Position) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.position = position
    }

    public var description: String {
        return "[\(position)]\(type) \(lexeme)"
    }
}
