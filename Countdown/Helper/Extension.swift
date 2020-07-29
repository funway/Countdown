//
//  Extension.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SQLite

extension FileManager {
    func directoryExists(_ atPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: atPath, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}


/**
* 使得 SQLite.swift 可以实现 UUID 类型到 String 的自动转换
*/
extension UUID: SQLite.Value {
    public typealias Datatype = String
    
    public static var declaredDatatype: String {
        return Datatype.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ datatypeValue: Datatype) -> UUID {
        let uuid = UUID(uuidString: datatypeValue)
        if uuid == nil {
            log.error("字符串 \(datatypeValue) 无法解析成 UUID，重新生成一个 UUID 返回")
            return UUID()
        }
        return uuid!
    }
    
    public var datatypeValue: Datatype {
        return self.uuidString
    }
}


/**
 * 使得 SQLite.swift 可以实现 UUID 类型到 SQLite.Blob 的自动转换
 */
//extension UUID: SQLite.Value {
//    public typealias Datatype = SQLite.Blob
//
//    public static var declaredDatatype: String {
//        return Datatype.declaredDatatype
//    }
//
//    public static func fromDatatypeValue(_ datatypeValue: Datatype) -> UUID {
//        let bytes = datatypeValue.bytes
//        return UUID(uuid: (bytes[0], bytes[1], bytes[2], bytes[3],
//                           bytes[4], bytes[5], bytes[6], bytes[7],
//                           bytes[8], bytes[9], bytes[10], bytes[11],
//                           bytes[12], bytes[13], bytes[14], bytes[15]))
//    }
//    public var datatypeValue: Datatype {
//        var bytes = [UInt8](repeating: 0, count: 16)
//        (bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7], bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]) = self.uuid
//        return Datatype(bytes: bytes)
//    }
//}
