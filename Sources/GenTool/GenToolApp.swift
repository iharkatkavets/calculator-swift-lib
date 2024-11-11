import ArgumentParser
import Foundation

@main
struct GenToolApp: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "gentool",
        abstract: "A tool for generating classes"
    )
    @Argument(help: "Destination folder") var outDir: Path

    mutating func run() throws {
        let types = [
            "Binary- left: Expr, oprtr: Token, right: Expr",
            "Grouping- expr: Expr",
            "Literal- value: Double",
            "Unary- oprtr: Token, right: Expr",
            "Function- oprtr: Token, right: Expr",
        ]
        try defineAst("Expr", types)
    }

    private func defineAst(
        _ baseName: String,
        _ types: [String]
    ) throws {
        let fileURL = outDir.url.appendingPathComponent(baseName + ".swift")
        print("outDir=\(outDir)")
        print("fileURL=\(fileURL)")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(atPath: fileURL.path)
        }
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        let fileHandle = FileHandle(forWritingAtPath: fileURL.path)
        if fileHandle == nil {
            print("file handle is nil")
        }

        try defineBaseType(fileHandle, baseName)
        try fileHandle?.write("\n\n")
        try defineVisitor(fileHandle, baseName, types)
        try fileHandle?.write("\n\n")

        for str in types {
            let className = str.components(separatedBy: "-")[0]
            let fields = str.components(separatedBy: "-")[1].trimmingCharacters(
                in: .whitespacesAndNewlines
            ).components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            try defineType(fileHandle, baseName, className, fields)
            try fileHandle?.write("\n\n")
        }
    }

    private func defineBaseType(
        _ fileHandle: FileHandle?,
        _ baseClass: String
    )
        throws
    {
        try fileHandle?.write("\n")
        try fileHandle?.write("public protocol Expr {")
        try fileHandle?.write("\n")
        try fileHandle?.write("\tfunc accept<V: Visitor>(_ visitor: V) throws -> V.R")
        try fileHandle?.write("\n")
        try fileHandle?.write("}")
        try fileHandle?.write("\n")
    }

    private func defineType(
        _ fileHandle: FileHandle?,
        _ baseName: String,
        _ className: String,
        _ fieldsList: [String]
    ) throws {
        try fileHandle?.write("\n")
        try fileHandle?.write("public struct \(className)\(baseName): \(baseName) {")
        try fileHandle?.write("\n")
        for field in fieldsList {
            try fileHandle?.write("\tlet \(field)")
            try fileHandle?.write("\n")
        }
        try fileHandle?.write("\n")
        try fileHandle?.write("\tpublic init(")
        for (i, field) in fieldsList.enumerated() {
            try fileHandle?.write("_ \(field)")
            if i + 1 < fieldsList.count {
                try fileHandle?.write(", ")
            }
        }
        try fileHandle?.write(") {")
        try fileHandle?.write("\n")
        for field in fieldsList {
            let f = field.components(separatedBy: ":")[0].trimmingCharacters(
                in: .whitespacesAndNewlines)
            try fileHandle?.write("\t\tself.\(f) = \(f)\n")
        }
        try fileHandle?.write("\t}")
        try fileHandle?.write("\n\n")
        try fileHandle?.write("\tpublic func accept<V: Visitor>(_ visitor: V) throws -> V.R {")
        try fileHandle?.write("\n")
        try fileHandle?.write("\t\treturn try visitor.visit\(className)\(baseName)(self)")
        try fileHandle?.write("\n")
        try fileHandle?.write("\t}")
        try fileHandle?.write("\n")
        try fileHandle?.write("}")

    }

    private func defineVisitor(
        _ fileHandle: FileHandle?,
        _ baseName: String,
        _ types: [String]
    ) throws {
        try fileHandle?.write("public protocol Visitor {")
        try fileHandle?.write("\n")
        try fileHandle?.write("associatedtype R")
        try fileHandle?.write("\n")
        for str in types {
            let className = str.components(separatedBy: "-")[0]
            try fileHandle?.write(
                "\tfunc visit\(className)\(baseName)(_ expr: \(className)\(baseName)) throws -> R")
            try fileHandle?.write("\n")
        }
        try fileHandle?.write("}")
    }

    struct Path: ExpressibleByArgument {
        var url: URL

        init?(argument: String) {
            guard let url = URL(string: argument) else {
                return nil
            }

            let exists = FileManager.default.fileExists(atPath: url.path)
            guard exists else {
                return nil
            }

            self.url = url
        }
    }
}
