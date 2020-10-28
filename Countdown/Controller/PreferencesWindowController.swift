//
//  PreferencesWindowController.swift
//  Countdown
//
//  Created by funway on 2020/10/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI

final class PreferencesWindowController {
    static let shared = PreferencesWindowController()
    
    private init() { }
    
    var window: NSWindow!
    
    func show() {
        log.debug("show preferences window")
        
        if window == nil {
            log.debug("window is nil. create it")
            let contentView = PreferencesView()
            window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                              styleMask: [.titled, .closable, .fullSizeContentView],
                              backing: .buffered, defer: false)
            window.center()
            window.setFrameAutosaveName("Preferences Window")
            window.contentView = NSHostingView(rootView: contentView)
            window.isReleasedWhenClosed = false
        }
        
        log.debug("make window front")
        window.makeKeyAndOrderFront(nil)
    }
}
