// MARK: - Body

public enum PlateDesignation: String, Sendable, CaseIterable {

    /// 마이그레이션 및 저장된 데이터를 메모리에 올리는 과정을 담당하는 플레이트.
    case restoration
    /// 메인.
    case main
    /// 기본 게임.
    case basicGame
    /// 기본 게임의 튜토리얼.
    case basicGameTutorial
    // 세팅.
    case settings

    /// 조금이라도 투명한 부분이 있어서 플레이트 너머가 보일 수 있는 경우에는 false.
    public func isOpaque() -> Bool {
        switch self {
        case .basicGameTutorial:
            return false
        default:
            return true
        }
    }
}
