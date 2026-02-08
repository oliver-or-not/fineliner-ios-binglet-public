// MARK: - Module Dependency

import SwiftUI

// MARK: - Body

public extension DS.PaletteColor {

    static let clear: Color =
        .init(.displayP3, red: 1, green: 1, blue: 1, opacity: 0)
    static let white: Color = .init(.displayP3, red: 1, green: 1, blue: 1)
    static let black: Color = .init(.displayP3, red: 0, green: 0, blue: 0)
    static let gray: Color = .init(.displayP3, red: 0.4, green: 0.4, blue: 0.4)

    static let red: Color = .init(.displayP3, red: 1, green: 0, blue: 0)
    static let green: Color = .init(.displayP3, red: 0, green: 1, blue: 0)
    static let blue: Color = .init(.displayP3, red: 0, green: 0, blue: 1)
    static let cyan: Color = .init(.displayP3, red: 0, green: 1, blue: 1)
    static let magenta: Color = .init(.displayP3, red: 1, green: 0, blue: 1)
    static let yellow: Color = .init(.displayP3, red: 1, green: 1, blue: 0)
}
