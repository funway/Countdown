//
//  TimerView.swift
//  Countdown
//
//  Created by funway on 2020/8/1.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

class TimerViewController: NSViewController
{
    /**
     * 视图控制器的生命周期
     */
    override func viewWillAppear() {
        super.viewWillAppear()
        log.debug("view will appear")
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        log.debug("view did disappear")
    }
}


struct TimerView: View {
    @State var date1 = Date()
    @State var date2 = Date()
    @State var date3 = Date()
    @State var showSubView = false
    
    // 妈的这个 publisher 自动停掉后，不会自动重启啊
    @State var timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var timer2: Timer?
    
    @State var timer3: AutoCancellingTimer?
    
    var body: some View {
        ZStack{
            if showSubView {
                VStack {
                    Text("看看 timer2 会不会停止?")
                    Button("返回主视图") {
                        self.showSubView = false
                    }
                }
            }
            else {
                VStack {
                    Button("切换子视图"){
                        self.showSubView = true
                    }
                    Text("date1: \(date1)")
                        .onReceive(timer1) { currentTime in
                            self.date1 = currentTime
                            log.debug("🔴onReceive timer1 触发一次")
                        }
                    
                    Text("date2: \(date2)")
                        .onAppear(perform: {
                            // 这个方法是用的 default mode 啊，要手工改成 common mode
                            // let timer = Timer(timeInterval: 1.0, repeats: true, block: {})
                            // RunLoop.current.add(timer, forMode: .commonModes)
                            self.timer2 = Timer.scheduledTimer(withTimeInterval: 1,
                                            repeats: true,
                                            block: {_ in
                                              self.date2 = Date()
                                              log.debug("🔷onAppear timer2 触发一次")
                                             })
                            
                            self.timer1.upstream.connect().cancel()
                            self.timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        })
                        .onDisappear(perform: {
                            self.timer2?.invalidate()
                            self.timer2 = nil
                            log.debug("🔶 onDisappear 停止 timer2")
                            // 但是如果直接关闭窗口，是不会触发视图的 disappear 事件啊！
                            
                            self.timer3 = nil
                        })
                    
                    Text("date3: \(self.date3)")
                        .onAppear(perform: {
                            self.timer3 = AutoCancellingTimer(interval: 1, repeats: true, callback: {
                                log.debug("💛 timer3 触发一次")
                                self.date3 = Date()
                            })
                        })
                    .onDisappear(perform: {
                        self.timer3 = nil
                    })
                }
            }
        }
        .frame(width: 500, height: 300)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}


final class AutoCancellingTimer {
  private var timer: AutoCancellingTimerInstance?
  
  init(interval: TimeInterval, repeats: Bool = false, callback: @escaping ()->()) {
    timer = AutoCancellingTimerInstance(interval: interval, repeats: repeats, callback: callback)
  }
  
  deinit {
    log.debug("析构函数")
    timer?.cancel()
  }
  
  func cancel() {
    timer?.cancel()
  }
}

final class AutoCancellingTimerInstance: NSObject {
  private let repeats: Bool
  private var timer: Timer?
  private var callback: ()->()
  
  init(interval: TimeInterval, repeats: Bool = false, callback: @escaping ()->()) {
    self.repeats = repeats
    self.callback = callback
    
    super.init()
    
    timer = Timer.scheduledTimer(timeInterval: interval, target: self,
      selector: #selector(AutoCancellingTimerInstance.timerFired(_:)), userInfo: nil, repeats: repeats)
  }
  
  func cancel() {
    timer?.invalidate()
  }
  
    @objc func timerFired(_ timer: Timer) {
    self.callback()
    if !repeats { cancel() }
  }
}
