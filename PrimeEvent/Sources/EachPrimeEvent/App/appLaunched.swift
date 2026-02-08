// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Director
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let dateAgent = GlobalEntity.Agent.dateAgent
fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let appInfoAgent = GlobalEntity.Agent.appInfoAgent
fileprivate let appAppearanceAgent = GlobalEntity.Agent.appAppearanceAgent
fileprivate let idfaAgent = GlobalEntity.Agent.idfaAgent
fileprivate let gameCenterAgent = GlobalEntity.Agent.gameCenterAgent
fileprivate let shareAgent = GlobalEntity.Agent.shareAgent
@MainActor fileprivate let appStoreReviewAgent = GlobalEntity.Agent.appStoreReviewAgent
fileprivate let googleAdAgent = GlobalEntity.Agent.googleAdAgent
fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
fileprivate let soundAgent = GlobalEntity.Agent.soundAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent
fileprivate let appSwitchAgent = GlobalEntity.Agent.appSwitchAgent

fileprivate let restorationPlate = GlobalEntity.Plate.restorationPlate
fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let appLaunched: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .appLaunched, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Set Constants

    let now = await dateAgent.getNowDate()
    let buildNumber = await appInfoAgent.getBuildNumber()

    // MARK: - Activation

    await plateStackAgent.setActivationLevel(.active)

    // MARK: - Present Restoration Plate

    await plateStackAgent.pushPlate(.restoration, .withoutAnimation)

    // MARK: - Activation

    await dateAgent.setActivationLevel(.active)
    await appStateAgent.setActivationLevel(.active)
    await appInfoAgent.setActivationLevel(.active)
    await idfaAgent.setActivationLevel(.active)
    await gameCenterAgent.setActivationLevel(.active)
    await shareAgent.setActivationLevel(.active)
    await appStoreReviewAgent.setActivationLevel(.active)
    await hapticFeedbackAgent.setActivationLevel(.active)
    await appSwitchAgent.setActivationLevel(.active)
    await googleAdAgent.start()
    await googleAdAgent.setActivationLevel(.active)

    // MARK: - Before Migration

    let migratedBuildNumber = await appStateAgent.getMigratedBuildNumber()
    if migratedBuildNumber == nil {
        // 최초 실행인 경우. 현재 빌드 번호를 migratedBuildNumber로 지정한다.
        // 따라서 이 경우에는 마이그레이션이 진행되지 않는다.
        await appStateAgent.setMigratedBuildNumber(buildNumber)
    }

    // MARK: - Migration

    // MARK: - After Migration

    // 현재의 빌드 번호를 타겟으로 하는 마이그레이션 작업이 없더라도 현재의 빌드 번호를 migratedBuildNumber로 지정한다.
    await appStateAgent.setMigratedBuildNumber(buildNumber)

    // MARK: - App Appearance

    await appAppearanceAgent.setActivationLevel(.active)
    let colorSchemeFromAppState = await appStateAgent.getColorScheme()
    await appAppearanceAgent.setColorScheme(colorSchemeFromAppState)

    // MARK: - Sound

    await soundAgent.setActivationLevel(.active)

    let isBackgroundMusicOn = await appStateAgent.getIsBackgroundMusicOn()
    await soundAgent.setIsBackgroundMusicOn(isBackgroundMusicOn)
    let backgroundMusicVolume = await appStateAgent.getBackgroundMusicVolume()
    await soundAgent.setBackgroundMusicVolume(Float(backgroundMusicVolume))
    let isSoundEffectOn = await appStateAgent.getIsSoundEffectOn()
    await soundAgent.setIsSoundEffectOn(isSoundEffectOn)
    let soundEffectVolume = await appStateAgent.getSoundEffectVolume()
    await soundAgent.setSoundEffectVolume(Float(soundEffectVolume))

    // MARK: - App Id

    let customAppStoreAppId = await appInfoAgent.getCustomAppStoreAppId()
    await shareAgent.setLinkString(value: "https://apps.apple.com/app/id" + customAppStoreAppId)
    await appSwitchAgent.setLinkString(key: .appStorePageOfThisApp, value: "itms-apps://apps.apple.com/app/id" + customAppStoreAppId)

    // MARK: - Game Center Leaderboard Id

    let customGameCenterBasicGameGlobalAllTimeLeaderboardId = await appInfoAgent.getCustomGameCenterBasicGameGlobalAllTimeLeaderboardId()
    await gameCenterAgent.setLeaderboardId(key: .basicGameGlobalAllTime, value: customGameCenterBasicGameGlobalAllTimeLeaderboardId)

    // MARK: - Banner Ad

    let customGoogleAdUnitIdForBasicGamePlateBottomBannerAd = await appInfoAgent.getCustomGoogleAdUnitIdForBasicGamePlateBottomBannerAd()
    await basicGamePlate.setBannerAdUnitId(customGoogleAdUnitIdForBasicGamePlateBottomBannerAd)

    // MARK: - Present Main Plate

    await plateStackAgent.pushPlate(.main, .fadeIn)

    // MARK: - Request IDFA Authorization or Show Banner Ad

    let idfaAuthorizationStatus = await idfaAgent.currentAuthorizationStatus()
    if case .notDetermined = idfaAuthorizationStatus {
        await idfaAgent.requestAuthorization()
    } else {
        await basicGamePlate.setIsBannerAdShown(true)
    }
}
