//
//  PopRootViewController.swift
//  Countdown
//
//  Created by funway on 2020/8/9.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

class PopRootViewController: NSViewController
{
    /**
     * 视图控制器的生命周期
     */
    override func viewWillAppear() {
        log.verbose("PopRootView will appear")
        AppTimer.shared.start()
        super.viewWillAppear()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        AppTimer.shared.stop()
        log.verbose("PopRootView did disappear")
    }
}
