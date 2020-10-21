/*
 HoverAwareView.swift

 MIT License

 Copyright © 2020 github.com/aerobounce.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
  */

import SwiftUI

#if os(macOS)

public extension View {
    func onHoverAware(_ perform: @escaping (Bool) -> Void) -> some View {
        background(HoverAwareView { (value: Bool) in
            perform(value)
        })
    }
}

public struct HoverAwareView: View {
    public let onHover: (Bool) -> Void

    public var body: some View {
        Representable(onHover: onHover)
    }
}

private extension HoverAwareView {
    final class Representable: NSViewRepresentable {
        let onHover: (Bool) -> Void

        init(onHover: @escaping (Bool) -> Void) {
            self.onHover = onHover
        }

        func makeNSView(context: Context) -> NSHoverAwareView {
            NSHoverAwareView(onHover: onHover)
        }

        func updateNSView(_ nsView: NSHoverAwareView, context: Context) {}
    }
}

private extension HoverAwareView {
    final class NSHoverAwareView: NSView {
        let onHover: (Bool) -> Void

        init(onHover: @escaping (Bool) -> Void) {
            self.onHover = onHover
            super.init(frame: .zero)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func updateTrackingAreas() {
            for area in trackingAreas {
                removeTrackingArea(area)
            }

            guard bounds.size.width > 0, bounds.size.height > 0 else { return }

            let options: NSTrackingArea.Options = [
                .mouseEnteredAndExited,
                .activeInActiveApp,
                .assumeInside,
            ]

            let trackingArea: NSTrackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
            addTrackingArea(trackingArea)
        }

        override func mouseEntered(with event: NSEvent) {
            onHover(true)
        }

        override func mouseExited(with event: NSEvent) {
            onHover(false)
        }
    }
}

#endif
