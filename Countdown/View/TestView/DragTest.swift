//
//  DragTest.swift
//  Countdown
//
//  Created by funway on 2020/8/12.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

// 2020.08.13
//1、如果 foreach 不包裹在 list 中的话，onmove() 好像是无效的
//2、list 的底层是依赖于 NSTableView 的，所以可以强制扩展 NSTableView 来修改 list 的样式（https://stackoverflow.com/questions/59394085/swiftui-liststyle-on-macos）

struct DragTest: View {
    @State var hoveredList = false
    @State var hoveredEventUUID: UUID? = nil
    @State var refreshBody = 0
    @State var cdEvents = loadCountdownEvent()
    
    @State private var links: [URL] = [
        URL(string: "https://twitter.com/mecid")!,
        URL(string: "https://baidu.com/")!,
        URL(string: "https://google.com/")!,
        URL(string: "https://weibo.com/mecid")!
    ]

    var body: some View {
        VStack {
            Text("\(self.refreshBody) [\(UUID())]")
            
            List {
                ForEach(cdEvents, id: \.uuid) { cdEvent in
                    VStack(spacing: 0){
                        EventRow(cdEvent: cdEvent)
                        Divider()
                    }
                }
                .onMove(perform: move)
                .padding(.horizontal, -8) // 这个 padding 是为了抵消 List 的 padding
            }
            
            Divider()
            
            VStack(spacing: 0) {
                ForEach(cdEvents, id: \.uuid) { cdEvent in
                    VStack(spacing: 0){
                        EventRow(cdEvent: cdEvent)
                        Divider()
                    }
                }
            }
        }.frame(width: 360)
        
    }

    func move(from source: IndexSet, to destination: Int) {
        log.debug("move??? to: \(destination)")
        cdEvents.move(fromOffsets: source, toOffset: destination)
        log.debug(source.count)
        for s in source {
            log.debug(s)
        }
//        self.refreshBody += 1
//        users.move(fromOffsets: source, toOffset: destination)
    }
}

struct DragTest_Previews: PreviewProvider {
    static var previews: some View {
        DragTest()
    }
}

struct EventRowDropDelegate: DropDelegate {
    
    func performDrop(info: DropInfo) -> Bool {
        log.debug("EventRowDropDelegate???")
        
        guard info.hasItemsConforming(to: ["public.url"]) else {
            return false
        }
        
        return true
    }
}

