// MARK: - Body

public enum BasicGameTutorialState: Hashable, Sendable {

    case initial
    case greeting
    case movingRequested
    case firstBingletPlacingAccomplished
    case bingleRequested
    case bingleAccomplished
    case comboCountExplained
    case comboBingleRequested
    case comboBingleAccomplished
    case farewell

    public var next: BasicGameTutorialState? {
        switch self {
        case .initial:
            return .greeting
        case .greeting:
            return .movingRequested
        case .movingRequested:
            return .firstBingletPlacingAccomplished
        case .firstBingletPlacingAccomplished:
            return .bingleRequested
        case .bingleRequested:
            return .bingleAccomplished
        case .bingleAccomplished:
            return .comboCountExplained
        case .comboCountExplained:
            return .comboBingleRequested
        case .comboBingleRequested:
            return .comboBingleAccomplished
        case .comboBingleAccomplished:
            return .farewell
        case .farewell:
            return nil
        }
    }
}
