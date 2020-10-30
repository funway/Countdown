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
    
    func makeNSViewController(context: Context) -> EventListNSTableController {
        log.verbose("makeNSViewController")
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        return appDelegate.eventListController
    }
    
    func updateNSViewController(_ nsViewController: EventListNSTableController, context: Context) {
        log.verbose("updateNSViewController")
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
            .frame(width: 340)
    }
}
