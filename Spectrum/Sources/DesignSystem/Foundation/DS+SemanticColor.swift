// MARK: - Module Dependency

import SwiftUI

// MARK: - Body

public extension DS.SemanticColor {

    static let dim: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(DS.PaletteColor.white.opacity(0.2))
            : UIColor(DS.PaletteColor.black.opacity(0.3))
        }
    )

    static let generalBackground: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "2A2A2A"))
            : UIColor(Color(hex: "EEEDED"))
        }
    )

    static let generalText: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(DS.PaletteColor.white)
            : UIColor(DS.PaletteColor.black)
        }
    )

    static let generalLoading: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(DS.PaletteColor.white.opacity(0.2))
            : UIColor(DS.PaletteColor.black.opacity(0.3))
        }
    )

    static let interactable: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(DS.PaletteColor.black)
            : UIColor(DS.PaletteColor.white)
        }
    )

    static let sectionBackground: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "597D80"))
            : UIColor(Color(hex: "C4EAED"))
        }
    )

    static let sectionInteractable: Color = Color(hex: "85D5DB")

    static let dialogBackground: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "597D80").opacity(0.87))
            : UIColor(Color(hex: "C4EAED").opacity(0.8))
        }
    )
    static let dialogButtonBackground: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "1A3D40").opacity(0.9))
            : UIColor(Color(hex: "9AE2DC").opacity(0.9))
        }
    )

    static let disabledInteractable: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "404040"))
            : UIColor(Color(hex: "DDDDDD"))
        }
    )

    static let disabledText: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "A0A0A0"))
            : UIColor(Color(hex: "B7B7B7"))
        }
    )
}
