import SwiftUI

public struct CircularProgress: View {
    var progress: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var lineWidth: CGFloat
    var animationTimeInterval: TimeInterval
    
    public init(progress: CGFloat, backgroundColor : Color = .gray, foregroundColor: Color = .pink,
                lineWidth: CGFloat = 10, animationTimeInterval: TimeInterval = 0.5) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.lineWidth = lineWidth
        self.animationTimeInterval = animationTimeInterval
    }
    
    public var body: some View {
        ZStack {
            Circle().strokeBorder(backgroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(0.5)
            
            Circle().trim(from: 0.0, to: self.progress)
                .stroke(foregroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .padding(.all, lineWidth/2)
                .animation(.linear(duration: animationTimeInterval))
        }
    }
}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(progress: 0.5)
    }
}
