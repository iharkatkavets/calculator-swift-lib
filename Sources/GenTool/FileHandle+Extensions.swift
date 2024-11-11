import Foundation

struct FileHandleWriteError: Error {

}

extension FileHandle {
    func write(_ str: String, _ encoding: String.Encoding = .utf8) throws(FileHandleWriteError) {
        guard let data = str.data(using: encoding) else {
            throw FileHandleWriteError()
        }
        write(data)
    }
}
