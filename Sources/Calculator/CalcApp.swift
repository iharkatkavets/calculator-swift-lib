// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import MathTree

@main
struct MathCalcApp: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "calc", abstract: "A simble calculator")
    @Argument(help: "Math expression \"3+sin(90)\"") var expression: String

    mutating func run() throws {
        do {
            let tokens = try Scanner(expression).scanTokens()
            let expr = try Parser(tokens).parse()

            print(try AstPrinter().print(expr))

            let result = try Interpreter().interpret(expr)

            print("Result: \(result)")

        } catch let error as ScanError {
            let reporter = TermErrorReporter(expression)
            reporter.reportError(error)

        } catch let error as ParseError {
            let reporter = TermErrorReporter(expression)
            reporter.reportError(error)
        }

    }

    private func printAST() {
    }

}
