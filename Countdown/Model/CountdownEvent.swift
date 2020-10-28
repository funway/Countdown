//
//  CountdownEvent.swift
//  Countdown
//
//  Created by funway on 2020/7/28.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import AppKit
import SQLite

class CountdownEvent: ObservableObject {
    private var id: Int!
    static let id = Expression<Int>("id")
    
    @Published var title: String
    static let title = Expression<String>("title")
    
    var uuid: UUID
    static let uuid = Expression<UUID>("uuid")
    
    @Published var endAt: Date
    static let endAt = Expression<Date>("endAt")
    
    var createAt: Date
    static let createAt = Expression<Date>("createAt")
    
    var deleteAt: Date?
    static let deleteAt = Expression<Date?>("deleteAt")
    
    var listOrder: Int
    static let listOrder = Expression<Int>("listOrder")
    
    @Published var remindMe: Bool
    static let remindMe = Expression<Bool>("remindMe")
    
    @Published var showStickyNote: Bool
    static let showStickyNote = Expression<Bool>("showStickyNote")
    
    @Published var color: NSColor
    static let color = Expression<NSColor>("color")
    
    var progress: Double {
        let p = (Date().timeIntervalSince1970 - createAt.timeIntervalSince1970)
                / (endAt.timeIntervalSince1970 - createAt.timeIntervalSince1970)
        return (p >= 0 && p <= 1) ? p : 1
    }
    
    @Published var displayedProgress: Double
    
    init(title: String,
         uuid: UUID = UUID(),
         endAt: Date = Date(timeIntervalSinceNow: 60*60),
         createAt: Date = Date(),
         color: NSColor = .red,
         remindMe: Bool = false,
         showStickyNote: Bool = false) {

        self.title = title
        self.uuid = uuid
        self.endAt = endAt
        self.createAt = createAt
        self.color = color
        
        self.listOrder = 0
        self.remindMe = remindMe
        self.showStickyNote = showStickyNote
        
        self.displayedProgress = (Date().timeIntervalSince1970 - createAt.timeIntervalSince1970)
                                / (endAt.timeIntervalSince1970 - createAt.timeIntervalSince1970)
        
        log.verbose("构造 CountdownEvent 对象: \(self)")
    }
    
    init(row: SQLite.Row) {
        
        self.id = row[CountdownEvent.id]
        self.title = row[CountdownEvent.title]
        self.uuid = row[CountdownEvent.uuid]
        self.endAt = row[CountdownEvent.endAt]
        self.createAt = row[CountdownEvent.createAt]
        self.deleteAt = row[CountdownEvent.deleteAt]
        self.listOrder = row[CountdownEvent.listOrder]
        self.remindMe = row[CountdownEvent.remindMe]
        self.showStickyNote = row[CountdownEvent.showStickyNote]
        self.color = row[CountdownEvent.color]

        self.displayedProgress = (Date().timeIntervalSince1970 - row[CountdownEvent.createAt].timeIntervalSince1970)
            / (row[CountdownEvent.endAt].timeIntervalSince1970 - row[CountdownEvent.createAt].timeIntervalSince1970)
        
        log.verbose("构造 CountdownEvent 对象: \(self)")
    }
    
    deinit {
        log.verbose("释放 CountdownEvent 对象: \(self)")
    }
    
    
    /// 创建表结构
    /// - Parameters:
    ///   - db: 数据库连接
    ///   - tableName: 表名，默认用本类型名字
    ///   - ifNotExists:
    /// - Throws:
    ///     如果表结构已存在且 ifNotExists 为 false，则抛出错误
    static func createTable(at db: Connection,
                            tableName: String = CountdownEvent.typeName,
                            ifNotExists: Bool = true) throws {
        let table = Table(tableName)
        
        do {
            try db.run(table.create(ifNotExists: ifNotExists) { t in
                t.column(self.id, primaryKey: true)    // id 为整形主键，非自增（默认会用 SQLite 的 rowid 进行赋值）
                t.column(self.title)
                t.column(self.uuid, unique: true)
                t.column(self.endAt)
                t.column(self.createAt)
                t.column(self.deleteAt)
                t.column(self.listOrder, defaultValue: 0)
                t.column(self.remindMe, defaultValue: false)
                t.column(self.showStickyNote, defaultValue: false)
                t.column(self.color, defaultValue: NSColor.red)
            })
        } catch {
            log.severe("Create table [\(tableName)] failed!")
            throw error
        }
    }
    
    
    
    /// 将数据保存到数据库
    /// - 如果 id = nil，则执行 insert 操作，并将返回的 rowid 赋值给实例的 id 属性
    /// - 如果 id != nil，则执行 update 操作，以 id 作为条件
    /// - Parameters:
    ///   - db: 数据库连接
    ///   - tableName: 表名，默认使用本类型名字
    func save(at db: Connection, tableName: String = CountdownEvent.typeName) {
        
        let table = Table(tableName)
        
        if self.id == nil {
            do {
                let rowid = try db.run(table.insert(CountdownEvent.title <- self.title,
                                                    CountdownEvent.uuid <- self.uuid,
                                                    CountdownEvent.createAt <- self.createAt,
                                                    CountdownEvent.endAt <- self.endAt,
                                                    CountdownEvent.deleteAt <- self.deleteAt,
                                                    CountdownEvent.listOrder <- self.listOrder,
                                                    CountdownEvent.remindMe <- self.remindMe,
                                                    CountdownEvent.showStickyNote <- self.showStickyNote,
                                                    CountdownEvent.color <- self.color))
                self.id = Int(rowid)
                log.debug("Inserted id: \(rowid)")
            } catch {
                log.error("Insertion failed: \(error)")
            }
        } else {
            do {
                let count = try db.run(table.filter(CountdownEvent.id == self.id)
                                            .update(CountdownEvent.title <- self.title,
                                                    CountdownEvent.uuid <- self.uuid,
                                                    CountdownEvent.createAt <- self.createAt,
                                                    CountdownEvent.endAt <- self.endAt,
                                                    CountdownEvent.deleteAt <- self.deleteAt,
                                                    CountdownEvent.listOrder <- self.listOrder,
                                                    CountdownEvent.remindMe <- self.remindMe,
                                                    CountdownEvent.showStickyNote <- self.showStickyNote,
                                                    CountdownEvent.color <- self.color))
                if count > 0 {
                    log.debug("Update succeeded, affected \(count) rows")
                } else {
                    log.error("Update failed: id [\(self.id!)] not found")
                }
            } catch {
                log.error("Update failed: \(error)")
            }
        }
    }
    
    
    
    /// 根据 id 从数据库中删除 CountdownEvent 事件
    /// - Parameters:
    ///   - db: 数据库链接
    ///   - tableName: 表名，默认使用本类型名
    ///   - softDelete: 是否为软删除，默认为是
    func delete(at db: Connection, tableName: String = CountdownEvent.typeName, softDelete: Bool = true) {
 
        if self.id == nil {
            log.error("Try to delete a CountdownEvent which id is nil")
            return
        }
        
        let table = Table(tableName)
        
        if softDelete {
            log.debug("Soft delete id [\(self.id!)]")
            self.deleteAt = Date()
            self.save(at: db, tableName: tableName)
        } else {
            do {
                let count = try db.run(table.filter(CountdownEvent.id == self.id )
                                            .delete())
                if count > 0 {
                    log.debug("Hard delete succeeded, affected \(count) rows")
                } else {
                    log.error("Hard delete failed: id [\(self.id!)] not found")
                }
            } catch {
                print("Hard delete failed: \(error)")
            }
        }
    }
}


extension CountdownEvent: CustomStringConvertible {
    var description: String {
        return "[uuid: \(self.uuid), title: \(self.title), endAt: \(self.endAt)], listOrder: \(self.listOrder), remind: \(self.remindMe), sticky: \(self.showStickyNote)"
    }
}


extension CountdownEvent: NameDescribable {

}
