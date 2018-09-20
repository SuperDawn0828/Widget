import Foundation

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    private var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    private var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    func hmac(_ value: String, key: String) -> String {
        let cStr = value.cString(using: .utf8)
        let cStrLen = Int(value.lengthOfBytes(using: .utf8))
        let digestLen = self.digestLength
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: .utf8))
        CCHmac(self.HMACAlgorithm, keyStr!, keyLen, cStr!, cStrLen, buffer)
        let output = NSMutableString(capacity: digestLen)
        for i in 0 ..< digestLen {
            output.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return output as String
    }
    
}

extension String {
    var md5: String {
        let cStr = self.cString(using: .utf8)
        let cStrLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(cStr!,(CC_LONG)(cStrLen), buffer)
        let md5String = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH))
        for i in 0 ..< digestLen {
            md5String.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}



extension String {
    var sha1: String {
        let cStr = self.cString(using: .utf8)
        let cStrLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA1(cStr!, CC_LONG(cStrLen), buffer)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for i in 0 ..< digestLen {
            output.appendFormat("%02X", buffer[i])
        }
        return output as String
        
    }
    
    var sha224: String {
        let cStr = self.cString(using: .utf8)
        let cStrLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA224_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA224(cStr!, CC_LONG(cStrLen), buffer)
        let output = NSMutableString(capacity: Int(CC_SHA224_DIGEST_LENGTH))
        for i in 0 ..< digestLen {
            output.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return output as String
    }
    
    var sha256: String {
        let cStr = self.cString(using: .utf8)
        let cStrLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA256(cStr!, CC_LONG(cStrLen), buffer)
        let output = NSMutableString(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        for i in 0 ..< digestLen {
            output.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return output as String
    }
    
    var sha384: String {
        let cStr = self.cString(using: .utf8)
        let cStrLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA384_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA384(cStr!, CC_LONG(cStrLen), buffer)
        let output = NSMutableString(capacity: Int(CC_SHA384_DIGEST_LENGTH))
        for i in 0 ..< digestLen {
            output.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return output as String
    }
    
    var sha512: String {
        let cStr = self.cString(using: .utf8)
        let cStrLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA512(cStr!, CC_LONG(cStrLen), buffer)
        let output = NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
        for i in 0 ..< digestLen {
            output.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return output as String
    }
}
