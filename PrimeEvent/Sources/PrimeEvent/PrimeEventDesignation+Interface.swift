// MARK: - Module Dependency

import Spectrum

// MARK: - Body

public extension PrimeEventDesignation {

    var interface: GlobalEntity.PrimeEvent.Interface {
        switch self {
#if DEBUG
        case .observationButtonTapped:
            GlobalEntity.PrimeEvent.observationButtonTapped
#endif
        case .appLaunched:
            GlobalEntity.PrimeEvent.appLaunched
        case .timeElapsed:
            GlobalEntity.PrimeEvent.timeElapsed
        case .audioSessionInterruptionBegan:
            GlobalEntity.PrimeEvent.audioSessionInterruptionBegan
        case .audioSessionInterruptionEnded:
            GlobalEntity.PrimeEvent.audioSessionInterruptionEnded
        case .audioSessionRouteChanged:
            GlobalEntity.PrimeEvent.audioSessionRouteChanged
        case .audioSessionMediaServicesWereReset:
            GlobalEntity.PrimeEvent.audioSessionMediaServicesWereReset
        case .mainPlateShareButtonTapped:
            GlobalEntity.PrimeEvent.mainPlateShareButtonTapped
        case .mainPlateMarathonButtonTapped:
            GlobalEntity.PrimeEvent.mainPlateMarathonButtonTapped
        case .mainPlateRankingsButtonTapped:
            GlobalEntity.PrimeEvent.mainPlateRankingsButtonTapped
        case .mainPlateSettingsButtonTapped:
            GlobalEntity.PrimeEvent.mainPlateSettingsButtonTapped
        case .mainPlateIdfaAuthorizationGranted:
            GlobalEntity.PrimeEvent.mainPlateIdfaAuthorizationGranted
        case .mainPlateIdfaAuthorizationDenied:
            GlobalEntity.PrimeEvent.mainPlateIdfaAuthorizationDenied
        case .basicGamePlateBackButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateBackButtonTapped
        case .basicGamePlateHowToPlayButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateHowToPlayButtonTapped
        case .basicGamePlateResetButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateResetButtonTapped
        case .basicGamePlateBeforeResetDialogResetButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateBeforeResetDialogResetButtonTapped
        case .basicGamePlateBeforeResetDialogCancelButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateBeforeResetDialogCancelButtonTapped
        case .basicGamePlateGameBoardTapped:
            GlobalEntity.PrimeEvent.basicGamePlateGameBoardTapped
        case .basicGamePlateGameBoardDragged:
            GlobalEntity.PrimeEvent.basicGamePlateGameBoardDragged
        case .basicGamePlateGameBoardDragEnded:
            GlobalEntity.PrimeEvent.basicGamePlateGameBoardDragEnded
        case .basicGamePlatePlaceButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlatePlaceButtonTapped
        case .basicGamePlateResultDialogBackButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateResultDialogBackButtonTapped
        case .basicGamePlateResultDialogRestartButtonTapped:
            GlobalEntity.PrimeEvent.basicGamePlateResultDialogRestartButtonTapped
        case .basicGameTutorialPlateCloseButtonTapped:
            GlobalEntity.PrimeEvent.basicGameTutorialPlateCloseButtonTapped
        case .basicGameTutorialPlateGameBoardTapped:
            GlobalEntity.PrimeEvent.basicGameTutorialPlateGameBoardTapped
        case .basicGameTutorialPlateGameBoardDragged:
            GlobalEntity.PrimeEvent.basicGameTutorialPlateGameBoardDragged
        case .basicGameTutorialPlateGameBoardDragEnded:
            GlobalEntity.PrimeEvent.basicGameTutorialPlateGameBoardDragEnded
        case .basicGameTutorialPlatePlaceButtonTapped:
            GlobalEntity.PrimeEvent.basicGameTutorialPlatePlaceButtonTapped
        case .basicGameTutorialPlateTutorialGuideDialogButtonTapped:
            GlobalEntity.PrimeEvent.basicGameTutorialPlateTutorialGuideDialogButtonTapped
        case .settingsPlateCloseButtonTapped:
            GlobalEntity.PrimeEvent.settingsPlateCloseButtonTapped
        case .settingsPlateHapticFeedbackToggleTapped:
            GlobalEntity.PrimeEvent.settingsPlateHapticFeedbackToggleTapped
        case .settingsPlateAppearancePickerPicked:
            GlobalEntity.PrimeEvent.settingsPlateAppearancePickerPicked

        }
    }
}
