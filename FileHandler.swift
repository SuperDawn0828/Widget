import Foundation

final class FileHandler {
    
    enum Directory {
        case document
        case library
        case caches
        
        var path: String {
            switch self {
            case .document:
                return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            case .library:
                return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            case .caches:
                return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            }
        }
    }
    
    struct FilePath: RawRepresentable {
        
        typealias RawValue = String

        var rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    static let handler = FileHandler()
    private init() {}
    
    private func directoryPath(_ directory: Directory, path: FilePath ) -> String {
        return directory.path + "/" + path.rawValue
    }
    
    private func filePath(_ directory: Directory, path: FilePath, fileName: String) -> String {
        return directoryPath(directory, path: path) + "/" + fileName
    }
    
    private func createDirectory(_ directory: Directory, path: FilePath) -> Bool {
        let fileManager = FileManager.default
        let dirPath = directoryPath(directory, path: path)
        var isDir: ObjCBool = false
        let isExist = fileManager.fileExists(atPath: dirPath, isDirectory: &isDir)
        if isDir.boolValue && isExist {
            return true
        } else {
            do {
               try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                return false
            }
        }
    }
    
    @discardableResult
    func save(data: Data, to directory: Directory, path: FilePath, fileName: String) -> Bool {
        let filePath = self.filePath(directory, path: path, fileName: fileName)
        print(filePath)
        if createDirectory(directory, path: path) {
            return FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        } else {
            return false
        }
    }
    
    func deleteFile(by directory: Directory, path: FilePath, fileName: String) throws {
        let filePath = self.filePath(directory, path: path, fileName: fileName)
        try FileManager.default.removeItem(atPath: filePath)
    }
    
    func readFile(by directory: Directory, path: FilePath, fileName: String) -> Data? {
        let filePath = self.filePath(directory, path: path, fileName: fileName)
       return FileManager.default.contents(atPath: filePath)
    }
    
    func isExist(at directory: Directory, path: FilePath, fileName: String) -> Bool {
        let filePath = self.filePath(directory, path: path, fileName: fileName)
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    func fileList(at directory: Directory, path: FilePath) throws -> [String] {
        let dirPath = directoryPath(directory, path: path)
        return FileManager.default.contentsOfDirectory(atPath: dirPath)
    }
}
