import Foundation
import MathTree
import Rainbow

struct TermErrorReporter: ErrorReporter {
    private let expression: String

    init(_ expression: String) {
        self.expression = expression
    }

    func reportError(_ error: ScanError) {
        printExpression()
        error.errors.forEach {
            showErrorAtPosition($0)
        }
    }

    func reportError(_ error: ParseError) {
        print("Parse error")
    }

    private func printExpression() {
        print(expression)
    }

    private func showErrorAtPosition(_ error: (Position, String)) {
        let offset = String(repeating: " ", count: error.0)
        let line = offset + "^--\(error.1)"
        print(line.red)
    }
}
