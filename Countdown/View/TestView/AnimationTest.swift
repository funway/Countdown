//
//  AnimationTest.swift
//  Countdown
//
//  Created by funway on 2020/8/8.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    // 自定义 transition 类型
    static var customedMoveAndFade: AnyTransition {
        // 通过 .combined 组合不同的 transition
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        
        // 通过 .asymmetric 设置不同的 入/出 transition
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct AnimationTest: View {
    @State var trans = false
    @State var animation = false
    @State var animation2 = false
    
    var body: some View {
        VStack {
            Text("动画测试")
            
            Divider()
            
            // animation 测试
            ZStack {
                Rectangle().fill(Color.yellow)
                    .opacity(0.3)
                    .frame(height: 50)
                
                HStack {
                    Button("Toggle Animation") {
                        self.animation.toggle()
                    }
                    
                    Spacer()
                    
                    Image("RightIcon")
                        .rotationEffect(.degrees(animation ? 90 : 0))
                        .scaleEffect(animation ? 1.5 : 1)
                        .animation(.easeIn)
                    
                    Image("RightIcon")
                        .rotationEffect(.degrees(animation ? 90 : 0))
                        .scaleEffect(animation ? 1.5 : 1)
                        .animation(.spring())
                }
            }
            
            
            // animation 第二种方式
            ZStack {
                Rectangle().fill(Color.blue)
                    .opacity(0.3)
                    .frame(height: 50)
                
                HStack {
                    Button("Toggle Animation 2") {
                        withAnimation(.easeInOut(duration: 2)) {
                            self.animation2.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    Image("RightIcon")
                        .rotationEffect(.degrees(animation2 ? 90 : 180))
                        .scaleEffect(animation2 ? 1 : 1.5)
                    
                    Image("RightIcon")
                        .rotationEffect(.degrees(animation2 ? 90 : 180))
                        .scaleEffect(animation2 ? 1 : 1.5)
                }
            }
            
            
            // transition 测试
            ZStack {
                Rectangle().fill(Color.gray)
                    .opacity(0.3)
                    .frame(height: 50)
                
                HStack {
                    Button("Toggle Transition") {
                        // 通过 duration 设置动画时间
                        withAnimation(.easeOut(duration: 1)) {
                            self.trans.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    if self.trans {
                        Button(action: {}) {
                            Image("RightIcon")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .transition(.move(edge: .trailing))
                        
                        Button(action: {}) {
                            Image("RightIcon")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .transition(.opacity)
                        
                        // 所以 transition 这么叠加是无效的，只有第一个 tansition 起作用
                        Button(action: {}) {
                            Image("RightIcon")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .transition(.opacity)
                        .transition(.move(edge: .trailing))
                        
                        // transition 的叠加需要用 AnyTransition.combined 方法
                        Button(action: {}) {
                            Image("RightIcon")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .transition(AnyTransition.opacity.combined(with: .move(edge: .top)))
                        
                        
                        // 使用自定义的 transition
                        Button(action: {}) {
                            Image("RightIcon")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .transition(.customedMoveAndFade)
                    }
                }
            }
            
        }
        .padding()
        .frame(width: 600, height: 600)
    }
}

struct AnimationTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimationTest()
    }
}
