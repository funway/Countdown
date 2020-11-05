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


extension Date {
    
    /// 对 https://github.com/melvitax/DateHelper 的 toStringWithRelativeTime( ) 方法进行了修改
    func toStringWithRelativeTimeEx(strings:[RelativeTimeStringType:String]? = nil) -> String {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        let sec:Double = abs(now - time)
        let min:Double = round(sec/60)
        let hr:Double = round(min/60)
        let d:Double = round(hr/24)
        
        switch toRelativeTime() {
        case .nowPast:
            return strings?[.nowPast] ?? NSLocalizedString("just now", comment: "Date format")
        case .nowFuture:
            return String(
                format: strings?[.secondsFuture] ?? NSLocalizedString("in %.f seconds", comment: "Date format"),
                sec
            )
        case .secondsPast:
            return String(
                format: strings?[.secondsPast] ?? NSLocalizedString("%.f seconds ago", comment: "Date format"),
                sec
            )
        case .secondsFuture:
            return String(
                format: strings?[.secondsFuture] ?? NSLocalizedString("in %.f seconds", comment: "Date format"),
                sec
            )
        case .oneMinutePast:
            return strings?[.oneMinutePast] ?? NSLocalizedString("1 minute ago", comment: "Date format")
        case .oneMinuteFuture:
            return strings?[.oneMinuteFuture] ?? NSLocalizedString("in 1 minute", comment: "Date format")
        case .minutesPast:
            return String(
                format: strings?[.minutesPast] ?? NSLocalizedString("%.f minutes ago", comment: "Date format"),
                min
            )
        case .minutesFuture:
            return String(
                format: strings?[.minutesFuture] ?? NSLocalizedString("in %.f minutes", comment: "Date format"),
                min
            )
        case .oneHourPast:
            return strings?[.oneHourPast] ?? NSLocalizedString("last hour", comment: "Date format")
        case .oneHourFuture:
            return strings?[.oneHourFuture] ?? NSLocalizedString("next hour", comment: "Date format")
        case .hoursPast:
            return String(
                format: strings?[.hoursPast] ?? NSLocalizedString("%.f hours ago", comment: "Date format"),
                hr
            )
        case .hoursFuture:
            return String(
                format: strings?[.hoursFuture] ?? NSLocalizedString("in %.f hours", comment: "Date format"),
                hr
            )
        case .oneDayPast:
            return strings?[.oneDayPast] ?? NSLocalizedString("yesterday", comment: "Date format")
        case .oneDayFuture:
            return strings?[.oneDayFuture] ?? NSLocalizedString("tomorrow", comment: "Date format")
        case .daysPast:
            return String(
                format: strings?[.daysPast] ?? NSLocalizedString("%.f days ago", comment: "Date format"),
                d
            )
        case .daysFuture:
            return String(
                format: strings?[.daysFuture] ?? NSLocalizedString("in %.f days", comment: "Date format"),
                d
            )
        case .oneWeekPast:
            return strings?[.oneWeekPast] ?? NSLocalizedString("last week", comment: "Date format")
        case .oneWeekFuture:
            return strings?[.oneWeekFuture] ?? NSLocalizedString("next week", comment: "Date format")
        case .weeksPast:
            let string = strings?[.weeksPast] ?? NSLocalizedString("%.f weeks ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .week))))
        case .weeksFuture:
            let string = strings?[.weeksFuture] ?? NSLocalizedString("in %.f weeks", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .week))))
        case .oneMonthPast:
            return strings?[.oneMonthPast] ?? NSLocalizedString("last month", comment: "Date format")
        case .oneMonthFuture:
            return strings?[.oneMonthFuture] ?? NSLocalizedString("next month", comment: "Date format")
        case .monthsPast:
            let string = strings?[.monthsPast] ?? NSLocalizedString("%.f months ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .month))))
        case .monthsFuture:
            let string = strings?[.monthsFuture] ?? NSLocalizedString("in %.f months", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .month))))
        case .oneYearPast:
            return strings?[.oneYearPast] ?? NSLocalizedString("last year", comment: "Date format")
        case .oneYearFuture:
            return strings?[.oneYearFuture] ?? NSLocalizedString("next year", comment: "Date format")
        case .yearsPast:
            let string = strings?[.yearsPast] ?? NSLocalizedString("%.f years ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .year))))
        case .yearsFuture:
            let string = strings?[.yearsFuture] ?? NSLocalizedString("in %.f years", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .year))))
        }
    }
}
