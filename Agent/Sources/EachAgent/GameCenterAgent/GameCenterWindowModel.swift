import Observation

@MainActor @Observable public final class GameCenterWindowModel {

    public static let shared = GameCenterWindowModel(
        gameCenterGraphicInterfaceRequestSignal: 0
    )

    public var gameCenterGraphicInterfaceRequestSignal: Int

    private init(
        gameCenterGraphicInterfaceRequestSignal: Int
    ) {
        self.gameCenterGraphicInterfaceRequestSignal = gameCenterGraphicInterfaceRequestSignal
    }
}
