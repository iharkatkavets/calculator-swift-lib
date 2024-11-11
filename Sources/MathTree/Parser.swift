/*

expression -> literal | unary | binary | grouping | function
literal -> number
grouping -> "(" expression ")"
unary -> "-" expression
binary -> expression operator expression
operator -> "+" "-" "*" "/"
function -> function "(" expression ")"

--

Name	Operators	Associates
term	"+" "-"		Left
factor	"*" "/"		Left
unary	"-"		Right
function "sin" "cos"
	"tg"		Right

--

expression -> term
term -> factor (( "+" / "-" ) factor)*
factor -> unary ( ( "/" | "*" ) unary )*
unary -> "-" unary | primary
primary -> function | number | "(" expression ")"
function -> IDENTIFIER "(" expression ")"

*/

import Foundation

public class Parser {
	private let tokens: [Token]
	private var current = 0
	private var isEndReached: Bool {
		return peek().type == .EOF
	}

	public init(_ tokens: [Token]) {
		self.tokens = tokens
	}

	public func parse() throws(ParseError) -> Expr {
		do {
			return try expression()
		} catch let error {
			throw error
		}
	}

	private func expression() throws(ParseError) -> any Expr {
		return try term()
	}

	private func term() throws(ParseError) -> any Expr {
		var expr = try factor()
		while match(.plus, .minus) {
			let oprtr = previous()
			let right = try factor()
			expr = BinaryExpr(expr, oprtr, right)
		}
		return expr

	}

	private func factor() throws(ParseError) -> any Expr {
		var expr = try unary()
		while match(.star, .slash) {
			let oprtr = previous()
			let right = try unary()
			expr = BinaryExpr(expr, oprtr, right)
		}
		return expr
	}

	private func unary() throws(ParseError) -> any Expr {
		if match(.minus) {
			let oprtr = previous()
			let right = try unary()
			return UnaryExpr(oprtr, right)
		}
		return try primary()
	}

	private func primary() throws(ParseError) -> any Expr {
		if match(.sin, .cos, .tg, .sqrt) {
			let oprt = previous()
			let right = try function()
			return FunctionExpr(oprt, right)
		}
		if match(.number) {
			guard let number = previous().literal as? Double else {
				throw error(previous(), "Must be number")
			}
			return LiteralExpr(number)
		}
		if match(.leftParen) {
			let expr = try expression()
			try consume(.rightParen, "Expect ')' after expression.")
			return GroupingExpr(expr)
		}
		return try expression()
	}

	@discardableResult
	private func consume(_ type: TokenType, _ message: String) throws(ParseError) -> Token {
		if check(type) {
			return advance()
		}
		throw error(peek(), message)
	}

	private func error(_ token: Token, _ message: String) -> ParseError {
		return ParseError()
	}

	private func function() throws(ParseError) -> any Expr {
		try consume(.leftParen, "Expect function starst from '('.")
		let expr = try expression()
		try consume(.rightParen, "Expect function ends with ')'.")
		return expr
	}

	private func match(_ types: TokenType...) -> Bool {
		for type in types {
			if check(type) {
				advance()
				return true
			}
		}
		return false
	}

	private func check(_ type: TokenType) -> Bool {
		if isEndReached {
			return false
		}
		return peek().type == type
	}

	@discardableResult
	private func advance() -> Token {
		if !isEndReached {
			current += 1
		}
		return previous()
	}

	private func peek() -> Token {
		return tokens[current]
	}

	private func previous() -> Token {
		return tokens[current - 1]
	}
}
