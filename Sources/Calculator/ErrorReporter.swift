import Foundation
import MathTree

protocol ErrorReporter {
    func reportError(_ error: ScanError)
    func reportError(_ error: ParseError)
}
