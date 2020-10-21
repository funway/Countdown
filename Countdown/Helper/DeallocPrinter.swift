//
//  DeallocPrinter.swift
//  Countdown
//
//  Created by funway on 2020/9/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation


/// 由于 Swfit 的结构体没有析构函数，可以在结构体中定义一个 DeallocPrinter 实例作为存储属性
/// 当结构体实例被释放时，就会释放该 DeallocPrinter 实例
class DeallocPrinter {
    private let forType: String
    
    init(forType: String) {
        self.forType = forType
        
        log.verbose("构造 \(forType) 实例中的 DeallocPrinter 对象")
    }
    
    deinit {
        log.verbose("释放 \(forType) 实例中的 DeallocPrinter 对象")
    }
}
