//
//  StickyNoteWindow.swift
//  Countdown
//
//  Created by funway on 2020/8/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI

class StickyNoteWindow: NSWindow {
    override var canBecomeKey: Bool {
        return false
    }
    
    deinit {
        log.verbose("释放 StickyNoteWindow 对象")
    }
}

