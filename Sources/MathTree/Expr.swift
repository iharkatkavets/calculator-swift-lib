public protocol Expr {
	func accept<V: Visitor>(_ visitor: V) throws -> V.R
}

public protocol Visitor {
	associatedtype R
	func visitBinaryExpr(_ expr: BinaryExpr) throws -> R
	func visitGroupingExpr(_ expr: GroupingExpr) throws -> R
	func visitLiteralExpr(_ expr: LiteralExpr) throws -> R
	func visitUnaryExpr(_ expr: UnaryExpr) throws -> R
	func visitFunctionExpr(_ expr: FunctionExpr) throws -> R
}

public struct BinaryExpr: Expr {
	let left: Expr
	let oprtr: Token
	let right: Expr

	public init(_ left: Expr, _ oprtr: Token, _ right: Expr) {
		self.left = left
		self.oprtr = oprtr
		self.right = right
	}

	public func accept<V: Visitor>(_ visitor: V) throws -> V.R {
		return try visitor.visitBinaryExpr(self)
	}
}

public struct GroupingExpr: Expr {
	let expr: Expr

	public init(_ expr: Expr) {
		self.expr = expr
	}

	public func accept<V: Visitor>(_ visitor: V) throws -> V.R {
		return try visitor.visitGroupingExpr(self)
	}
}

public struct LiteralExpr: Expr {
	let value: Any

	public init(_ value: Any) {
		self.value = value
	}

	public func accept<V: Visitor>(_ visitor: V) throws -> V.R {
		return try visitor.visitLiteralExpr(self)
	}
}

public struct UnaryExpr: Expr {
	let oprtr: Token
	let right: Expr

	public init(_ oprtr: Token, _ right: Expr) {
		self.oprtr = oprtr
		self.right = right
	}

	public func accept<V: Visitor>(_ visitor: V) throws -> V.R {
		return try visitor.visitUnaryExpr(self)
	}
}

public struct FunctionExpr: Expr {
	let oprtr: Token
	let right: Expr

	public init(_ oprtr: Token, _ right: Expr) {
		self.oprtr = oprtr
		self.right = right
	}

	public func accept<V: Visitor>(_ visitor: V) throws -> V.R {
		return try visitor.visitFunctionExpr(self)
	}
}
