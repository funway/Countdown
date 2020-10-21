//
//  Extension.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI


extension FileManager {
    
    /// 判断目录是否存在
    /// - Parameter atPath: 目标目录
    /// - Returns: 存在返回 true，不存在返回 false
    func directoryExists(_ atPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: atPath, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}


/// 给类或结构体添加 typeNmae 计算属性（包括静态/非静态），返回类型名
protocol NameDescribable {
    /// 获取类型名
    var typeName: String { get }
    
    /// 获取类型名
    static var typeName: String { get }
}
extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: Self.self)
    }
}

