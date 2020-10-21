//
//  SystemUIGuide.swift
//  Countdown
//
//  Created by funway on 2020/8/7.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct SystemUIGuide: View {
    var body: some View {
        VStack(spacing: 3) {
            Text("Primary").background(Color.primary)
            Text("secondary").background(Color.secondary)
            Text("accentColor").background(Color.accentColor)
            Text("clear").background(Color.clear)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SystemUIGuide_Previews: PreviewProvider {
    static var previews: some View {
        SystemUIGuide()
    }
}
