//
//  MouseUpDown.swift
//  Countdown
//
//  Created by funway on 2020/10/4.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import Combine

class Model: ObservableObject {
    var timerPublisher: Timer.TimerPublisher?
    var handle: AnyCancellable?
    var startstop: Cancellable?
    func createTimerPublisher() {
        timerPublisher = Timer.publish(every: 0.5, on: RunLoop.main, in: .default)
        handle = timerPublisher?.sink(receiveValue: {
            print($0)
            self.objectWillChange.send()
        })
    }
    init() {
        createTimerPublisher()
    }
    func start() {
        // if
        startstop = timerPublisher?.connect()
        print("start")
    }
    func stop() {
        startstop?.cancel()
        startstop = nil
        print("stop")
        // or create it conditionaly for later use
        createTimerPublisher()
    }
}

struct MouseUpDown: View {
    @ObservedObject var model = Model()
    var body: some View {
        VStack {
            Button(action: {
                self.model.start()
            }) {
                Text("Start")
            }
            Button(action: {
                self.model.stop()
            }) {
                Text("Stop")
            }
            MouseUpDownRepresentable(content: Rectangle()).environmentObject(model)
            .frame(width: 50, height: 50)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

class MouseUpDownViewClass<Content>: NSHostingView<Content> where Content : View {
    let model: Model
    required init(model: Model, rootView: Content) {
        self.model = model
        super.init(rootView: rootView)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }

    override func mouseUp(with event: NSEvent) {
        print("mouse up")
        model.stop()
    }
    override func mouseDown(with event: NSEvent) {
        print("mouse down")
        model.start()
    }
}

struct MouseUpDownRepresentable<Content>: NSViewRepresentable where Content: View {
    @EnvironmentObject var model: Model
    let content: Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        return MouseUpDownViewClass(model: model, rootView: self.content)
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
    }
}


