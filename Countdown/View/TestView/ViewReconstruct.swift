//
//  ViewReconstruct.swift
//  Countdown
//
//  Created by funway on 2020/8/11.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

class ObservableTest: ObservableObject {
    var uuid = UUID()
    @Published var score = 10
}

struct ViewReconstruct: View {
    private var uuid = UUID()
    @EnvironmentObject var envObj: ObservableTest
    
    init() {
        NSLog("🌞 主视图实例 初始化")
    }
    
    var body: some View {
        VStack {
            Text("🌞 主视图 \(self.uuid)").font(.system(.callout, design: .monospaced))
            HStack {
                Text("envObj: \(envObj.score) [\(envObj.uuid)]")
                Stepper("", onIncrement: {
                    self.envObj.score = self.envObj.score + 1
                }, onDecrement: {
                    self.envObj.score = self.envObj.score - 1
                })
            }
            
            Divider()
            
            ViewReconstructSubView()
            
            Divider()
            
            ViewReconstructBindingSubView()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ViewReconstructSubView: View {
    private var uuid = UUID()
    
    init() {
        NSLog("🌍 子视图实例 初始化")
    }
    
    var body: some View {
        VStack {
            Text("🌍 子视图 \(self.uuid)").font(.system(.callout, design: .monospaced))
        }
    }
}


struct ViewReconstructBindingSubView: View {
    private var uuid = UUID()
    
    @EnvironmentObject var envObj: ObservableTest
    
    init() {
        NSLog("🌛 子视图实例 初始化")
    }
    
    var body: some View {
        VStack {
            Text("🌛 子视图 \(self.uuid)").font(.system(.callout, design: .monospaced))
            
            HStack {
                Text("envObj: \(envObj.score) [\(envObj.uuid)]")
                Stepper("", onIncrement: {
                    self.envObj.score = self.envObj.score + 1
                }, onDecrement: {
                    self.envObj.score = self.envObj.score - 1
                })
            }
        }
    }
}




struct ViewReconstruct_Previews: PreviewProvider {
    static var previews: some View {
        ViewReconstruct()
    }
}
