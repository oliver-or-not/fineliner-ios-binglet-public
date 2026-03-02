// MARK: - Module Dependency

import SwiftUI
import Spectrum
import AgentBase

// MARK: - Body

extension GlobalEntity.Agent {

    public static let appStateAgent: AppStateAgentInterface = AppStateAgent(
        activationLevel: .inactive
    )
}

public protocol AppStateAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    /// 마이그레이션이 완료된 빌드 번호.
    func getMigratedBuildNumber() async -> Int?
    /// 마이그레이션이 완료된 빌드 번호.
    func setMigratedBuildNumber(_ value: Int?) async

    /// 인스톨 id. 유저 식별자 역할을 한다.
    func getInstallId() async -> String
    /// 인스톨 id. 유저 식별자 역할을 한다.
    func setInstallId(_ value: String) async

    /// 화면 모드.
    func getColorScheme() async -> AppColorScheme
    /// 화면 모드.
    func setColorScheme(_ value: AppColorScheme) async

    /// 햅틱 피드백 on/off.
    func getIsHapticFeedbackOn() async -> Bool
    /// 햅틱 피드백 on/off.
    func setIsHapticFeedbackOn(_ value: Bool) async

    /// 게임 스냅샷.
    func getBasicGameSnapshot() async -> BasicGameSnapshot?
    /// 게임 스냅샷.
    func setBasicGameSnapshot(_ value: BasicGameSnapshot?) async

    /// 최근 게임 결과 정보의 배열.
    func getRecentResultArrayOfBasicGame() async -> [BasicGameResult]
    /// 최근 게임 결과 정보의 배열.
    func setRecentResultArrayOfBasicGame(_ value: [BasicGameResult]) async
}

fileprivate final actor AppStateAgent: AppStateAgentInterface {

    // MARK: - Reference

    private let storageWorker = AppStateAgentStorageWorker()
    /// 마이그레이션이 완료된 빌드 번호.
    private lazy var migratedBuildNumber: AppStateAgentStorableItem<Int, Int?> = .init(
        storageKey: .migratedBuildNumber,
        storageToRamTypeCastingClosure: { $0 },
        ramToStorageTypeCastingClosure: { $0 },
        storageWorker: storageWorker
    )
    /// 인스톨 id. 유저 식별자 역할을 한다.
    private lazy var installId: AppStateAgentStorableItem<String, String> = .init(
        storageKey: .installId,
        storageToRamTypeCastingClosure: { stored in stored ?? UUID().uuidString },
        ramToStorageTypeCastingClosure: { $0 },
        storageWorker: storageWorker
    )
    private lazy var colorScheme: AppStateAgentStorableItem<AppColorScheme, AppColorScheme> = .init(
        storageKey: .colorScheme,
        storageToRamTypeCastingClosure: { stored in stored ?? .unspecified },
        ramToStorageTypeCastingClosure: { $0 },
        storageWorker: storageWorker
    )
    /// 햅틱 피드백 on/off.
    private lazy var isHapticFeedbackOn: AppStateAgentStorableItem<Bool, Bool> = .init(
        storageKey: .isHapticFeedbackOn,
        storageToRamTypeCastingClosure: { stored in stored ?? true },
        ramToStorageTypeCastingClosure: { $0 },
        storageWorker: storageWorker
    )
    /// 게임 스냅샷.
    private lazy var basicGameSnapshot: AppStateAgentStorableItem<BasicGameSnapshot, BasicGameSnapshot?> = .init(
        storageKey: .basicGameSnapshot,
        storageToRamTypeCastingClosure: { $0 },
        ramToStorageTypeCastingClosure: { $0 },
        storageWorker: storageWorker
    )
    /// 최근 게임 결과 정보의 배열.
    private lazy var recentResultArrayOfBasicGame: AppStateAgentStorableItem<[BasicGameResult], [BasicGameResult]> = .init(
        storageKey: .recentResultArrayOfBasicGame,
        storageToRamTypeCastingClosure: { stored in stored ?? [] },
        ramToStorageTypeCastingClosure: { $0 },
        storageWorker: storageWorker
    )

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .appState

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - AppStateAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func getMigratedBuildNumber() async -> Int? {
        await migratedBuildNumber.get()
    }
    func setMigratedBuildNumber(_ value: Int?) async {
        await migratedBuildNumber.set(value)
    }

    func getInstallId() async -> String {
        await installId.get()
    }
    func setInstallId(_ value: String) async {
        await installId.set(value)
    }


    func getColorScheme() async -> AppColorScheme {
        await colorScheme.get()
    }

    func setColorScheme(_ value: AppColorScheme) async {
        await colorScheme.set(value)
    }

    func getIsHapticFeedbackOn() async -> Bool {
        await isHapticFeedbackOn.get()
    }
    func setIsHapticFeedbackOn(_ value: Bool) async {
        await isHapticFeedbackOn.set(value)
    }

    /// 게임 스냅샷.
    func getBasicGameSnapshot() async -> BasicGameSnapshot? {
        await basicGameSnapshot.get()
    }
    /// 게임 스냅샷.
    func setBasicGameSnapshot(_ value: BasicGameSnapshot?) async {
        await basicGameSnapshot.set(value)
    }

    func getRecentResultArrayOfBasicGame() async -> [BasicGameResult] {
        await recentResultArrayOfBasicGame.get()
    }
    func setRecentResultArrayOfBasicGame(_ value: [BasicGameResult]) async {
        await recentResultArrayOfBasicGame.set(value)
    }
}
