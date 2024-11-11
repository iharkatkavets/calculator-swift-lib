import Foundation
import Testing

struct TermErrorReporterTests {
    func readFromStdout(_ str: String) throws -> String {
        let originalStdout = dup(STDOUT_FILENO)
        let pipe = Pipe()
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

        FileHandle.standardOutput.write(str.data(using: .utf8)!)

        pipe.fileHandleForWriting.closeFile()
        dup2(originalStdout, STDOUT_FILENO)
        close(originalStdout)

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let str = String(data: data, encoding: .utf8)!
        return str
    }

    @Test func writeToStdout() throws {
        let str = "Hello world2!"
        #expect(try readFromStdout(str) == str)
    }

    @Test func writeToStdoutFromPosition() throws {

    }
}
