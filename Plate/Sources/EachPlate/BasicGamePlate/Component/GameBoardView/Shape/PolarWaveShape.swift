import SwiftUI

struct PolarWaveShape: Shape {

    var c: CGFloat      // 기본 반지름
    var amplitude: CGFloat // 진폭
    var n: CGFloat      // 반복 수 (꽃잎 수)
    var phaseAngle: CGFloat
    var resolution: Int // 선 분할

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()
        var isFirst = true

        for step in 0...resolution {
            let t = CGFloat(step) / CGFloat(resolution) * 2 * .pi
            let r = c + amplitude * sin(n * t + phaseAngle)
            let x = center.x + r * cos(t)
            let y = center.y + r * sin(t)

            if isFirst {
                path.move(to: CGPoint(x: x, y: y))
                isFirst = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}
