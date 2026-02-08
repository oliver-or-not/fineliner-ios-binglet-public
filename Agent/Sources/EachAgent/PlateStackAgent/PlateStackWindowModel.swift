// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Body

@MainActor @Observable public final class PlateStackWindowModel {

    public static let shared = PlateStackWindowModel(
        stablePlateDesignationArray: [],
        stablePlateDistance: 0,
        stablePlateRelativeOffset: CGPoint(),
        stablePlateCornerRadius: 0,
        stablePlateOpacity: 0,
        unstablePlateDesignation: nil,
        unstablePlateDistance: 0,
        unstablePlateRelativeOffset: CGPoint(),
        unstablePlateCornerRadius: 0,
        unstablePlateOpacity: 0
    )

    /// 안정적인 플레이트 배열.
    public var stablePlateDesignationArray: [PlateDesignation]
    public var stablePlateDistance: CGFloat
    public var stablePlateRelativeOffset: CGPoint
    public var stablePlateCornerRadius: CGFloat
    public var stablePlateOpacity: CGFloat
    /// 추가되거나 사라지는 과정의 플레이트.
    public var unstablePlateDesignation: PlateDesignation?
    public var unstablePlateDistance: CGFloat
    public var unstablePlateRelativeOffset: CGPoint
    public var unstablePlateCornerRadius: CGFloat
    public var unstablePlateOpacity: CGFloat

    private init(
        stablePlateDesignationArray: [PlateDesignation],
        stablePlateDistance: CGFloat,
        stablePlateRelativeOffset: CGPoint,
        stablePlateCornerRadius: CGFloat,
        stablePlateOpacity: CGFloat,
        unstablePlateDesignation: PlateDesignation?,
        unstablePlateDistance: CGFloat,
        unstablePlateRelativeOffset: CGPoint,
        unstablePlateCornerRadius: CGFloat,
        unstablePlateOpacity: CGFloat
    ) {
        self.stablePlateDesignationArray = stablePlateDesignationArray
        self.stablePlateDistance = stablePlateDistance
        self.stablePlateRelativeOffset = stablePlateRelativeOffset
        self.stablePlateCornerRadius = stablePlateCornerRadius
        self.stablePlateOpacity = stablePlateOpacity
        self.unstablePlateDesignation = unstablePlateDesignation
        self.unstablePlateDistance = unstablePlateDistance
        self.unstablePlateRelativeOffset = unstablePlateRelativeOffset
        self.unstablePlateCornerRadius = unstablePlateCornerRadius
        self.unstablePlateOpacity = unstablePlateOpacity
    }
}
