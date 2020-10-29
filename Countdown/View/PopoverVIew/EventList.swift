//
//  EventList.swift
//  Countdown
//
//  Created by funway on 2020/10/8.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import AppKit


/// 将一个 NSTableVIew 包装成 SwiftUI.View 进行使用
struct EventList: NSViewControllerRepresentable {
    typealias NSViewControllerType = EventListNSTableController
    
    @EnvironmentObject var userData: UserData
    
    func makeNSViewController(context: Context) -> EventListNSTableController {
        return EventListNSTableController(userData: userData)
    }
    
    func updateNSViewController(_ nsViewController: EventListNSTableController, context: Context) {
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
            .frame(width: 340)
            .environmentObject(UserData.shared)
    }
}


final class EventListNSTableController: NSViewController {
    let userData: UserData
    
    var tableView = NSTableView()
    let scrollView = NSScrollView()
    
    init(userData: UserData) {
        self.userData = userData
        
        // 不从 nib 文件中加载视图，需要重写 loadView() 方法来手工加载视图
        super.init(nibName: nil, bundle: nil)
        log.verbose("初始化 EventListNSTableController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        log.verbose("释放 EventListNSTableController")
    }
    
    override func loadView() {
        view = BackgroundNSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置 NSTableView
        tableView.backgroundColor = .clear                          // 清空背景色
        tableView.usesAlternatingRowBackgroundColors = false        // 每行背景色是否交替
        tableView.selectionHighlightStyle = .none                   // 选中项不高亮
        tableView.intercellSpacing = NSSize(width: 0, height: 0)    // The horizontal and vertical spacing between cells
        tableView.usesAutomaticRowHeights = true                    // 自动计算行高
        tableView.headerView = nil                                  // 不显示列头
        
        tableView.addTableColumn(NSTableColumn())                   // 手工添加一列
        
        tableView.registerForDraggedTypes([.string])                // 设置 pasteboard 中用来标识被抓取项的 NSPasteboardItem 的数据类型
    
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.action = #selector(onItemClicked)                 // 选中某项时触发的事件处理
        
        
        // 设置 NSScrollView
        scrollView.documentView = tableView
        scrollView.drawsBackground = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.borderType = .noBorder

        view.addSubview(scrollView)
    }
    
    /// 当 NSTableVIew 中某一个项被选中后触发
    @objc private func onItemClicked() {
        log.verbose("点击 NSTableView [row \(tableView.clickedRow), col \(tableView.clickedColumn)]")
        
        // 如果用户点击在非数据行列上时候，clickRow 与 clickedColumn 会是-1
        if tableView.clickedRow < 0 {
            return
        }
        
        // 设置当前点击的倒计时事件
        userData.currentClickedEvent = userData.countdownEvents[tableView.clickedRow]
        withAnimation {
            // 跳转到编辑视图
            userData.currentPopContainedViewType = PopContainedViewType.edit
        }
    }
}

extension EventListNSTableController: NSTableViewDelegate {
    
    // 为 NSTableView 返回每一行 View
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let eventRow = EventRow(cdEvent: userData.countdownEvents[row]).border(width: 1, edges: [.bottom], color: Color.gray.opacity(0.2))
       
        let view = NSHostingView(rootView: eventRow)
        
        return view
    }
}

extension EventListNSTableController: NSTableViewDataSource {
    
    // 在 NSTableView 中抓取某项时自动调用该函数
    // 返回需要写入到 pasteboard 中的，可以唯一标识该 row 的数据
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        return userData.countdownEvents[row].uuid.uuidString as NSString
    }

    // 在 NSTableView 中抓取某项并移动时自动调用该函数
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        if dropOperation == .above {
            tableView.draggingDestinationFeedbackStyle = .gap
            return .move
        } else {
            return []
        }
    }

    // 在 NSTableView 中抓取某项并释放时自动调用该函数
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {

        /* Read the pasteboard items and ensure there is at least one item,
         find the string of the first pasteboard item and search the datasource
         for the index of the matching string */
        guard let items = info.draggingPasteboard.pasteboardItems,
            let pasteBoardItem = items.first,
            let pasteBoardItemName = pasteBoardItem.string(forType: .string),
            let index = userData.countdownEvents.firstIndex(where: {$0.uuid.uuidString == pasteBoardItemName}) else { return false }
        
        // 修改 userData.countdownEvents 数组
        let indexset = IndexSet(integer: index)
        userData.countdownEvents.move(fromOffsets: indexset, toOffset: row)
        
        // 修改每个 CountdownEvent 对象的 listOrder 属性，并写入数据库
        for index in 0 ..< self.userData.countdownEvents.count {
            self.userData.countdownEvents[index].listOrder = index
            self.userData.countdownEvents[index].save(at: db)
        }

        /* Animate the move to the rows in the table view. The ternary operator
         is needed because dragging a row downwards means the row number is 1 less */
        tableView.beginUpdates()
        tableView.moveRow(at: index, to: (index < row ? row - 1 : row))
        tableView.endUpdates()

        return true
    }


    func numberOfRows(in tableView: NSTableView) -> Int {
        return userData.countdownEvents.count
    }
}

extension EventListNSTableController {
    private class BackgroundNSView: NSView {
        override func draw(_ dirtyRect: NSRect) {
            // 调用 set() 方法设置当前画笔颜色
            NSColor.clear.set()
            
            // 填色
            dirtyRect.fill()
        }
    }
}
