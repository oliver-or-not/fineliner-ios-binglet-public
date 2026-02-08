// MARK: - Module Dependency

import UIKit
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

extension GlobalEntity.Agent {

    public static let appInfoAgent: AppInfoAgentInterface = AppInfoAgent(
        activationLevel: .inactive
    )
}

public protocol AppInfoAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func getBuildNumber() async -> Int

    func getBundleId() async -> String

    func getCustomAppStoreAppId() async -> String

    func getCustomGameCenterBasicGameGlobalAllTimeLeaderboardId() async -> String

    func getCustomGoogleAdUnitIdForBasicGamePlateBottomBannerAd() async -> String
}

fileprivate final actor AppInfoAgent: AppInfoAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .appInfo
    private let infoDictionary = Bundle.main.infoDictionary!

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - AppInfoAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func getBuildNumber() async -> Int {
        let buildNumberString = infoDictionary[AppInfoKey.cfBundleVersion.rawValue] as? String
        let safeBuildNumberString = buildNumberString ?? "0"
        if let buildNumber = Int(safeBuildNumberString) {
            return buildNumber
        } else {
            await logDirector.agentLog(
                .appInfo,
                .error,
                "Build number is not an integer: \(safeBuildNumberString); Returns 0 instead."
            )
            return 0
        }
    }

    func getBundleId() async -> String {
        let bundleIdString = infoDictionary[AppInfoKey.cfBundleIdentifier.rawValue] as? String
        if let bundleIdString {
            return bundleIdString
        } else {
            await logDirector.agentLog(
                .appInfo,
                .error,
                "Bundle Id is missing; Returns empty string instead."
            )
            return ""
        }
    }

    func getCustomAppStoreAppId() async -> String {
        let customAppStoreAppIdString = infoDictionary[AppInfoKey.customAppStoreAppId.rawValue] as? String
        if let customAppStoreAppIdString {
            return customAppStoreAppIdString
        } else {
            await logDirector.agentLog(
                .appInfo,
                .error,
                "customAppStoreAppId is missing; Returns empty string instead."
            )
            return ""
        }
    }

    func getCustomGameCenterBasicGameGlobalAllTimeLeaderboardId() async -> String {
        let customGameCenterBasicGameGlobalAllTimeLeaderboardIdString = infoDictionary[AppInfoKey.customGameCenterBasicGameGlobalAllTimeLeaderboardId.rawValue] as? String
        if let customGameCenterBasicGameGlobalAllTimeLeaderboardIdString {
            return customGameCenterBasicGameGlobalAllTimeLeaderboardIdString
        } else {
            await logDirector.agentLog(
                .appInfo,
                .error,
                "customGameCenterBasicGameGlobalAllTimeLeaderboardId is missing; Returns empty string instead."
            )
            return ""
        }
    }

    func getCustomGoogleAdUnitIdForBasicGamePlateBottomBannerAd() async -> String {
        let adUnitId = infoDictionary[AppInfoKey.customGoogleAdUnitIdForBasicGamePlateBottomBannerAd.rawValue] as? String
        if let adUnitId {
            return adUnitId
        } else {
            await logDirector.agentLog(
                .appInfo,
                .error,
                "customGoogleAdUnitIdForBasicGamePlateBottomBannerAd is missing; Returns empty string instead."
            )
            return ""
        }
    }

    // MARK: - Key

    enum AppInfoKey: String {

        case cfBundleVersion = "CFBundleVersion"
        case cfBundleIdentifier = "CFBundleIdentifier"
        case customAppStoreAppId = "CUSTOM_APP_STORE_APP_ID"
        case customGameCenterBasicGameGlobalAllTimeLeaderboardId = "CUSTOM_GAME_CENTER_BASIC_GAME_GLOBAL_ALL_TIME_LEADERBOARD_ID"
        case customGoogleAdUnitIdForBasicGamePlateBottomBannerAd = "CUSTOM_GOOGLE_AD_UNIT_ID_FOR_BASIC_GAME_BANNER_AD"
    }
}
