//
//  PopRootView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

class PopRootViewController: NSViewController
{
    // 内容为空即可
}

enum PopContainedViewType {
    case list
    case add
    case edit
    case detail
}

struct PopRootView: View {
    
    @State var containedViewType: PopContainedViewType = .list
    
    var body: some View {
        ZStack {
            if .list == self.containedViewType {
                PopEventList(currentPopContainedViewType: $containedViewType)
            }
            
            else if .add == self.containedViewType {
                PopEventAdd(currentPopContainedViewType: $containedViewType)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

struct PopRootView_Previews: PreviewProvider {
    static var previews: some View {
        PopRootView()
    }
}
