//
//  CountdownEvent.swift
//  Countdown
//
//  Created by funway on 2020/7/28.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SQLite

struct CountdownEvent {
    private var id: Int!
    static let id = Expression<Int>("id")
    
    var title: String
    static let title = Expression<String>("title")
    
    var uuid: UUID
    static let uuid = Expression<UUID>("uuid")
    
    var endAt: Date
    static let endAt = Expression<Date>("endAt")
    
    var createAt: Date
    static let createAt = Expression<Date>("createAt")
    
    var deleteAt: Date?
    static let deleteAt = Expression<Date?>("deleteAt")
    
    static var typeName: String {
        return String(describing: self)
    }
    
    init(title: String,
         uuid: UUID = UUID(),
         endAt: Date = Date(timeIntervalSinceNow: 60*60),
         createAt: Date = Date()) {
        self.title = title
        self.uuid = uuid
        self.endAt = endAt
        self.createAt = createAt
    }
    
    init(row: SQLite.Row) {
        self.id = row[CountdownEvent.id]
        self.title = row[CountdownEvent.title]
        self.uuid = row[CountdownEvent.uuid]
        self.endAt = row[CountdownEvent.endAt]
        self.createAt = row[CountdownEvent.createAt]
        self.deleteAt = row[CountdownEvent.deleteAt]
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
                t.column(self.id, primaryKey: true)
                t.column(self.title)
                t.column(self.uuid, unique: true)
                t.column(self.endAt)
                t.column(self.createAt)
                t.column(self.deleteAt)
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
    mutating func save(at db: Connection,
                       tableName: String = CountdownEvent.typeName) {
        
        let table = Table(tableName)
        
        if self.id == nil {
            do {
                let rowid = try db.run(table.insert(CountdownEvent.title <- self.title,
                                                    CountdownEvent.uuid <- self.uuid,
                                                    CountdownEvent.createAt <- self.createAt,
                                                    CountdownEvent.endAt <- self.endAt,
                                                    CountdownEvent.deleteAt <- self.deleteAt))
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
                                                    CountdownEvent.deleteAt <- self.deleteAt))
                if count > 0 {
                    log.debug("Update success")
                } else {
                    log.error("Update failed: id [\(String(self.id))] not found")
                }
            } catch {
                log.error("Update failed: \(error)")
            }
        }
    }
}
