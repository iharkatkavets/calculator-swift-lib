import Foundation

public struct ScanError: Error {
    public let errors: [(Position, String)]
}
