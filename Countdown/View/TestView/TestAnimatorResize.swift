//
//  TestAnimatorResize.swift
//  Countdown
//
//  Created by funway on 2020/10/24.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

class AniResizeWindow: NSWindow {
    
     var lastContentSize: CGSize = .zero

       override func setContentSize(_ size: NSSize) {
            NSLog("🌈 setContentSize \(lastContentSize) ==> \(size)")
           if lastContentSize == size { return } // prevent multiple calls with the same size

           lastContentSize = size

           var newOrigin = self.frame.origin
           newOrigin.y -= size.height - self.frame.height
           
           self.animator().setFrame(NSRect(origin: newOrigin, size: size), display: true, animate: true)
       }
}


class AniResizeWindowDelegate: NSObject, NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        log.debug("delegate to \(frameSize)")
        return frameSize
    }
}


struct TestAnimatorResize: View {
    @State var toggle = false
        
        var body: some View {
            VStack {
                Button("change") {
                    self.toggle.toggle()
                }
                
                if toggle {
                    VStack{
                        SettingsView()
                    }.frame(width: 400, height: 300)
                        
                } else {
                    VStack{
                        AboutView()
                    }.frame(width: 300, height: 400)
                }
            }
        }
}

struct TestAnimatorResize_Previews: PreviewProvider {
    static var previews: some View {
        TestAnimatorResize()
    }
}

//@State var toggle = false
//let delegate = AniResizeWindowDelegate()
//
//var body: some View {
//    VStack {
//        Button("toggle") {
//            self.toggle.toggle()
//        }
//
//        if toggle {
//            SettingsView()
//            .frame(width: 400, height: 400)
//        } else {
//            AboutView()
//            .frame(width: 400, height: 300)
//        }
//    }
//}
