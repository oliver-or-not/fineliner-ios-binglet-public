// MARK: - Body

public enum PlatePushStyle: Int, Sendable {

    case withoutAnimation = 0
    case fadeIn = 1
    case fromTrailing = 2
    case fromBottom = 3

    public var significance: Int {
        self.rawValue
    }

    public var correspondingPopStyle: PlatePopStyle {
        switch self {
        case .withoutAnimation:
            return .withoutAnimation
        case .fadeIn:
            return .fadeOut
        case .fromTrailing:
            return .toTrailing
        case .fromBottom:
            return .toBottom
        }
    }
}
