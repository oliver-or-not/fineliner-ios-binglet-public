// MARK: - Module Dependency

import SwiftUI

// MARK: - Body

public struct DSCircularLoadingView: View {

    public var color: Color
    @State private var isVisible: Bool = false

    public var body: some View {
        Circle()
            .trim(from: 0.2, to: 1.0)
            .stroke(color, lineWidth: 5)
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isVisible)
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: TimeInterval(seconds: 0.5).nanosecondsUInt64)
                    if !isVisible {
                        isVisible = true
                    }
                }
            }
            .opacity(isVisible ? 1 : 0)
    }

    public init(color: Color) {
        self.color = color
    }
}
