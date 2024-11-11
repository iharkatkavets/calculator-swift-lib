import Foundation

public class Interpreter: Visitor {
	public init() {

	}

	public func interpret(_ expr: Expr) throws -> Double {
		let value = try evaluate(expr)
		return try toDouble(value)
	}

	public func visitBinaryExpr(_ expr: BinaryExpr) throws -> Any {
		let left = try evaluate(expr.left)
		let right = try evaluate(expr.right)

		switch expr.oprtr.type {
		case .plus:
			return (try toDouble(right)) + (try toDouble(left))
		case .minus:
			return (try toDouble(right)) - (try toDouble(left))
		case .star:
			return (try toDouble(right)) * (try toDouble(left))
		case .slash:
			return (try toDouble(right)) / (try toDouble(left))
		default:
			throw RuntimeError(
				message: "Not reachable case \(expr.oprtr) in BinaryExpr")
		}
	}

	public func visitUnaryExpr(_ expr: UnaryExpr) throws -> Any {
		let right = try evaluate(expr.right)

		switch expr.oprtr.type {
		case .minus:
			return try toDouble(right)
		default:
			throw RuntimeError(
				message: "Not reachable case \(expr.oprtr) in UnaryExpr")
		}
	}

	private func toDouble(_ value: Any) throws -> Double {
		guard let double = value as? Double else {
			throw RuntimeError(message: "Value must be a number")
		}
		return double
	}

	public func visitLiteralExpr(_ expr: LiteralExpr) throws -> Any {
		return expr.value
	}

	public func visitGroupingExpr(_ expr: GroupingExpr) throws -> Any {
		return try evaluate(expr.expr)
	}

	public func visitFunctionExpr(_ expr: FunctionExpr) throws -> Any {
		let right = try evaluate(expr.right)

		switch expr.oprtr.type {
		case .sin:
			return sin(right as! Double)
		case .cos:
			return cos(right as! Double)
		case .tg:
			return tan(right as! Double)
		case .sqrt:
			return (right as! Double).squareRoot()
		default:
			throw RuntimeError(
				message: "Not reachable case \(expr.oprtr) in FunctionExpr")
		}
	}

	private func evaluate(_ expr: Expr) throws -> Any {
		return try expr.accept(self)
	}

}
