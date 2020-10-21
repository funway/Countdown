//
//  MagnificationGestureView.swift
//  Countdown
//
//  Created by funway on 2020/10/4.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct MagnificationGestureView: View {

    @GestureState var magnifyBy = CGFloat(1.0)

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }

    var body: some View {
        Circle()
            .frame(width: 100 * magnifyBy,
                   height: 100 * magnifyBy,
                   alignment: .center)
            .gesture(magnification)
    }
}

struct MagnificationGestureView_Previews: PreviewProvider {
    static var previews: some View {
        MagnificationGestureView()
    }
}
