// MARK: - Body

public enum AppStateAgentStorageKey: String, Sendable {

    case migratedBuildNumber = "migrated-build-number"
    case installId = "install-id"
    case colorScheme = "color-scheme"
    case isHapticFeedbackOn = "is-haptic-feedback-on"
    case basicGameSnapshot = "basic-game-snapshot"
    case recentResultArrayOfBasicGame = "recent-result-array-of-basic-game"
}
