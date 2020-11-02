import SwiftUI

/// 环状进度条
public struct CircularProgress: View {
    var progress: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var lineWidth: CGFloat
    var animationTimeInterval: TimeInterval
    var clockwise: Bool
    
    /// 环状进度条
    /// - Parameters:
    ///   - progress: 进度
    ///   - backgroundColor: 进度条背景色
    ///   - foregroundColor: 进度条颜色
    ///   - lineWidth: 进度条宽度
    ///   - animationTimeInterval: 动画间隔
    ///   - clockwise: 顺时针/逆时针
    public init(progress: CGFloat, backgroundColor : Color = .secondary, foregroundColor: Color = .pink,
                lineWidth: CGFloat = 10, animationTimeInterval: TimeInterval = 0.5, clockwise: Bool = true) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.lineWidth = lineWidth
        self.animationTimeInterval = animationTimeInterval
        self.clockwise = clockwise
    }
    
    public var body: some View {
        ZStack {
            Circle().strokeBorder(backgroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(0.2)
            
            Circle().trim(from: clockwise ? 0.0 : 1.0 - progress, to: clockwise ? self.progress : 1.0)
                .stroke(foregroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .padding(.all, lineWidth/2)
                .animation(.linear(duration: animationTimeInterval))
        }
    }
}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(progress: 0.1)
    }
}
