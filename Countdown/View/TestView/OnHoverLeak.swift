//
//  OnHoverLeak.swift
//  Countdown
//
//  Created by funway on 2020/10/2.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct OnHoverLeak: View {
    
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    
    var body: some View {
        VStack {
            Text("onHover() modifier result in memory leak").font(.headline)
            
            Divider()
            
            Text("onHover() 会导致内存泄漏，使得 View 结构体实例无法被释放")
                .onHover(perform: { hovered in
                    log.debug(hovered)
                })
        }.frame(width: 500, height: 300)
        
//        .onHoverAware({ hovered in
//            log.debug(hovered)
//        })
    }
}

struct OnHoverLeak_Previews: PreviewProvider {
    static var previews: some View {
        OnHoverLeak()
    }
}
