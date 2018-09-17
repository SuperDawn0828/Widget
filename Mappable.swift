import Foundation

enum MappableError: Error {
    case JSONStringToDataError
    case DataToJSONStringError
    case ObjectToDictionaryError
}

protocol Mappable: Codable { }

extension Mappable {
    
    static func arrayFromJSONString<T: Mappable>(_ jsonString: String, type: [T].Type) throws -> [T] {
        guard let data = jsonString.data(using: .utf8) else {
            throw MappableError.JSONStringToDataError
        }
        return try arrayFromData(data, type: type)
    }
    
    static func arrayFromArrayObject<T: Mappable>(_ object: [Any], type: [T].Type) throws -> [T] {
        let data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        return try arrayFromData(data, type: type)
    }
    
    static func arrayFromData<T: Mappable>(_ data: Data, type: [T].Type) throws -> [T] {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    static func initFromJSONString<T: Mappable>(_ jsonString: String, type: T.Type) throws -> T {
        guard let data = jsonString.data(using: .utf8) else {
            throw MappableError.JSONStringToDataError
        }
        return try initFromData(data, type: type)
    }
    
    static func initFromDictionaryObject<T: Mappable>(_ object: [String: Any], type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        return try initFromData(data, type: type)
    }
    
    static func initFromData<T: Mappable>(_ data: Data, type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}

extension Mappable {
    
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    func toDictionary() throws -> [String: Any] {
        let data = try toData()
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
        guard let dictionary = jsonObject as? [String: Any] else {
            throw MappableError.ObjectToDictionaryError
        }
        return dictionary
    }
    
    func toJSONString() throws -> String {
        let data = try toData()
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw MappableError.DataToJSONStringError
        }
        return jsonString
    }
}

extension Array where Element: Mappable {
    
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    func toJSONString() throws -> String {
        let data = try toData()
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw MappableError.DataToJSONStringError
        }
        return jsonString
    }
}

