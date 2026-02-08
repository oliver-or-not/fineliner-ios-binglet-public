// MARK: - Module Dependency

import SwiftUI

// MARK: - Body

extension Color {

    public func internalDivision(with another: Color, ratio: CGFloat) -> Color {
        let boundedRatio = min(max(ratio, 0), 1)

        var red: CGFloat = .zero
        var green: CGFloat = .zero
        var blue: CGFloat = .zero
        var alpha: CGFloat = .zero

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        var anotherRed: CGFloat = .zero
        var anotherGreen: CGFloat = .zero
        var anotherBlue: CGFloat = .zero
        var anotherAlpha: CGFloat = .zero

        UIColor(another).getRed(
            &anotherRed,
            green: &anotherGreen,
            blue: &anotherBlue,
            alpha: &anotherAlpha
        )

        return Color(uiColor: .init(
            red: red * (1 - boundedRatio) + anotherRed * boundedRatio,
            green: green * (1 - boundedRatio) + anotherGreen * boundedRatio,
            blue: blue * (1 - boundedRatio) + anotherBlue * boundedRatio,
            alpha: alpha * (1 - boundedRatio) + anotherAlpha * boundedRatio
        ))
    }
}

extension CGFloat {

    public func internalDivision(with another: CGFloat, ratio: CGFloat) -> CGFloat {
        let boundedRatio = Swift.min(Swift.max(ratio, 0), 1)
        return self * (1 - boundedRatio) + another * boundedRatio
    }
}

extension CGPoint {

    public func internalDivision(with another: CGPoint, ratio: CGFloat) -> CGPoint {
        CGPoint(
            x: self.x.internalDivision(with: another.x, ratio: ratio),
            y: self.y.internalDivision(with: another.y, ratio: ratio)
        )
    }
}
