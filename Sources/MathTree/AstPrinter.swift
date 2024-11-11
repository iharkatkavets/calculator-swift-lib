import Foundation

public struct AstPrinter: Visitor {
	public init() {}

	public func print(_ expr: Expr) throws -> String {
		return try expr.accept(self)
	}

	public func visitUnaryExpr(_ expr: UnaryExpr) throws -> String {
		return try parenthesize(expr.oprtr.lexeme, expr.right)
	}

	public func visitBinaryExpr(_ expr: BinaryExpr) throws -> String {
		return try parenthesize(expr.oprtr.lexeme, expr.left, expr.right)
	}

	public func visitLiteralExpr(_ expr: LiteralExpr) throws -> String {
		return String(describing: expr.value)
	}

	public func visitGroupingExpr(_ expr: GroupingExpr) throws -> String {
		return try parenthesize("group", expr.expr)
	}

	public func visitFunctionExpr(_ expr: FunctionExpr) throws -> String {
		return try parenthesize(expr.oprtr.lexeme, expr.right)
	}

	private func parenthesize(_ name: String, _ expr: Expr...) throws -> String {
		var result = "(\(name)"
		for e in expr {
			result.append(" ")
			result.append(try e.accept(self))
		}
		result.append(")")
		return result
	}
}
