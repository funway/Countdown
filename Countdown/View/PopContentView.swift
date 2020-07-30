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

enum PopContainedViewType {
    case list
    case add
    case edit
    case detail
}

struct PopContentView: View {
    
    @State var containedViewType: PopContainedViewType = .list
    
    var body: some View {
        ZStack {
            if .list == self.containedViewType {
                PopEventListView(currentPopContainedViewType: $containedViewType)
            }
            
            else if .add == self.containedViewType {
                PopEventAddView(currentPopContainedViewType: $containedViewType)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

struct PopContentView_Previews: PreviewProvider {
    static var previews: some View {
        PopContentView()
    }
}
