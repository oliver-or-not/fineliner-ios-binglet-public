// MARK: - Body

extension BackgroundMusicState {

    var isOnOrPaused: Bool {
        switch self {
        case .off:
            false
        case .paused, .on:
            true
        }
    }
}
