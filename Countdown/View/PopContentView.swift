//
//  PopContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

class PopContentViewController: NSViewController
{
    // 内容为空即可
}

struct PopContentView: View {
    var body: some View {
        VStack {
            HStack {
                
                Text("Countdown")
                
                Spacer()
                
                Button("+") {
                    log.debug("点击 + 按钮")
                }
            }
            
            Text("Hello, World!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button("Quit"){
                NSApplication.shared.terminate(self)
            }
        }.frame(width: 360, height: 360)
    }
}

struct PopContentView_Previews: PreviewProvider {
    static var previews: some View {
        PopContentView()
    }
}
