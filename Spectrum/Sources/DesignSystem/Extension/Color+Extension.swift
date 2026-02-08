// MARK: - Module Dependency

import SwiftUI

// MARK: - Body

public extension Color {

    /// RRGGBB 6자리 헥사코드를 받는다.
    init(_ colorSpace: Color.RGBColorSpace = .displayP3, hex: String, opacity: Double = 1) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6: // RRGGBB (24-bit)
            (r, g, b) = (
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(
            colorSpace,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: opacity
        )
    }
}
