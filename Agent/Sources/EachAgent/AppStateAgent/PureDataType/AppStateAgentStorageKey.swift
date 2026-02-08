// MARK: - Body

public enum AppStateAgentStorageKey: String, Sendable {

    case migratedBuildNumber = "migrated-build-number"
    case installId = "install-id"
    case colorScheme = "color-scheme"
    case isBackgroundMusicOn = "is-background-music-on"
    case backgroundMusicVolume = "background-music-volume"
    case isSoundEffectOn = "is-sound-effect-on"
    case soundEffectVolume = "sound-effect-volume"
    case isHapticFeedbackOn = "is-haptic-feedback-on"
    case basicGameSnapshot = "basic-game-snapshot"
    case recentResultArrayOfBasicGame = "recent-result-array-of-basic-game"
}
