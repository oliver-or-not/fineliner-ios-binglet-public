// MARK: - Module Dependency

import Foundation

// MARK: - Body

public enum PrimeEventDesignation: String, Sendable, CaseIterable {

#if DEBUG
    case observationButtonTapped
#endif

    /// 앱이 실행되었다.
    case appLaunched

    case timeElapsed

    case audioSessionInterruptionBegan
    case audioSessionInterruptionEnded
    case audioSessionRouteChanged
    case audioSessionMediaServicesWereReset

    case mainPlateShareButtonTapped
    case mainPlateMarathonButtonTapped
    case mainPlateRankingsButtonTapped
    case mainPlateSettingsButtonTapped
    case mainPlateIdfaAuthorizationGranted
    case mainPlateIdfaAuthorizationDenied

    case basicGamePlateBackButtonTapped
    case basicGamePlateHowToPlayButtonTapped
    case basicGamePlateResetButtonTapped
    case basicGamePlateBeforeResetDialogResetButtonTapped
    case basicGamePlateBeforeResetDialogCancelButtonTapped
    case basicGamePlateGameBoardTapped
    case basicGamePlateGameBoardDragged
    case basicGamePlateGameBoardDragEnded
    case basicGamePlatePlaceButtonTapped
    case basicGamePlateResultDialogBackButtonTapped
    case basicGamePlateResultDialogRestartButtonTapped

    case basicGameTutorialPlateCloseButtonTapped
    case basicGameTutorialPlateGameBoardTapped
    case basicGameTutorialPlateGameBoardDragged
    case basicGameTutorialPlateGameBoardDragEnded
    case basicGameTutorialPlatePlaceButtonTapped
    case basicGameTutorialPlateTutorialGuideDialogButtonTapped

    case settingsPlateCloseButtonTapped
    case settingsPlateHapticFeedbackToggleTapped
    case settingsPlateAppearancePickerPicked

    /// 두 prime event에 대응되는 작업을 병렬 실행해도 문제가 없다면 true를 반환한다.
    ///
    /// Category에 따른 판단보다 우선한다.
    public func isExceptionallyPerformCompatibleWith(_ another: PrimeEventDesignation) -> Bool {
        // 오래 걸릴 것으로 기대되는 작업이 끝나기 전에 특정 유저 인터랙션을 미리 허용하고 싶을 때 사용하면 적절하다.
        switch self {
        case .basicGamePlatePlaceButtonTapped:
            switch another {
            case .basicGamePlateGameBoardDragged:
                return true
            case .basicGamePlateGameBoardDragEnded:
                return true
            case .basicGamePlateGameBoardTapped:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    /// 두 prime event가 prime event 큐에 공존해도 괜찮다면 true를 반환한다.
    ///
    /// Category에 따른 판단보다 우선한다.
    public func isExceptionallyWaitCompatibleWith(_ another: PrimeEventDesignation) -> Bool {
        if isExceptionallyPerformCompatibleWith(another) {
            return true
        }
        // 유저의 빠른 연속 조작을 누락하지 않아야 할 때 사용하면 적절하다.
        switch self {
        case .basicGamePlateGameBoardDragged:
            switch another {
            case .basicGamePlateGameBoardDragEnded:
                return true
            default:
                return false
            }
        case .basicGameTutorialPlateGameBoardDragged:
            switch another {
            case .basicGameTutorialPlateGameBoardDragEnded:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    public var category: Category {
        switch self {
#if DEBUG
        case .observationButtonTapped:
                .friendly
#endif
        case .appLaunched:
                .hierarchical(scale: .app)
        case .timeElapsed:
                .natural
        case .audioSessionInterruptionBegan:
                .friendly
        case .audioSessionInterruptionEnded:
                .friendly
        case .audioSessionRouteChanged:
                .friendly
        case .audioSessionMediaServicesWereReset:
                .friendly
        case .mainPlateShareButtonTapped:
                .hierarchical(scale: .interplate)
        case .mainPlateMarathonButtonTapped:
                .hierarchical(scale: .interplate)
        case .mainPlateRankingsButtonTapped:
                .hierarchical(scale: .app)
        case .mainPlateSettingsButtonTapped:
                .hierarchical(scale: .interplate)
        case .mainPlateIdfaAuthorizationGranted:
                .hierarchical(scale: .boundedInPlate)
        case .mainPlateIdfaAuthorizationDenied:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateBackButtonTapped:
                .hierarchical(scale: .interplate)
        case .basicGamePlateHowToPlayButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateResetButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateBeforeResetDialogResetButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateBeforeResetDialogCancelButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateGameBoardTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateGameBoardDragged:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateGameBoardDragEnded:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlatePlaceButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGamePlateResultDialogBackButtonTapped:
                .hierarchical(scale: .interplate)
        case .basicGamePlateResultDialogRestartButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGameTutorialPlateCloseButtonTapped:
                .hierarchical(scale: .interplate)
        case .basicGameTutorialPlateGameBoardTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGameTutorialPlateGameBoardDragged:
                .hierarchical(scale: .boundedInPlate)
        case .basicGameTutorialPlateGameBoardDragEnded:
                .hierarchical(scale: .boundedInPlate)
        case .basicGameTutorialPlatePlaceButtonTapped:
                .hierarchical(scale: .boundedInPlate)
        case .basicGameTutorialPlateTutorialGuideDialogButtonTapped:
                .hierarchical(scale: .interplate)
        case .settingsPlateCloseButtonTapped:
                .hierarchical(scale: .interplate)
        case .settingsPlateHapticFeedbackToggleTapped:
                .hierarchical(scale: .boundedInPlate)
        case .settingsPlateAppearancePickerPicked:
                .hierarchical(scale: .boundedInPlate)
        }
    }

    public enum Category {

        /// 모든 prime event와 상호 performCompatible하다.
        case natural
        /// 모든 prime event와 상호 waitCompatible하다.
        case friendly
        /// 큐에 있는 모든 hierarchical prime event보다 스케일이 커야 enqueue될 수 있다.
        case hierarchical(scale: Scale)

        public enum Scale: Int {

            case boundedInPlate = 0
            case interplate = 1
            case app = 2
        }
    }
}

public enum PrimeEventDesignationWithPayload: Sendable {

#if DEBUG
    case observationButtonTapped
#endif

    /// 앱이 실행되었다.
    case appLaunched

    case timeElapsed(now: Date)

    case audioSessionInterruptionBegan
    case audioSessionInterruptionEnded
    case audioSessionRouteChanged
    case audioSessionMediaServicesWereReset

    case mainPlateShareButtonTapped
    case mainPlateMarathonButtonTapped
    case mainPlateRankingsButtonTapped
    case mainPlateSettingsButtonTapped
    case mainPlateIdfaAuthorizationGranted
    case mainPlateIdfaAuthorizationDenied

    case basicGamePlateBackButtonTapped
    case basicGamePlateHowToPlayButtonTapped
    case basicGamePlateResetButtonTapped
    case basicGamePlateBeforeResetDialogResetButtonTapped
    case basicGamePlateBeforeResetDialogCancelButtonTapped
    case basicGamePlateGameBoardTapped
    case basicGamePlateGameBoardDragged(translation: CGSize, unitDistance: CGFloat)
    case basicGamePlateGameBoardDragEnded
    case basicGamePlatePlaceButtonTapped
    case basicGamePlateResultDialogBackButtonTapped
    case basicGamePlateResultDialogRestartButtonTapped

    case basicGameTutorialPlateCloseButtonTapped
    case basicGameTutorialPlateGameBoardTapped
    case basicGameTutorialPlateGameBoardDragged(translation: CGSize, unitDistance: CGFloat)
    case basicGameTutorialPlateGameBoardDragEnded
    case basicGameTutorialPlatePlaceButtonTapped
    case basicGameTutorialPlateTutorialGuideDialogButtonTapped

    case settingsPlateCloseButtonTapped
    case settingsPlateHapticFeedbackToggleTapped
    case settingsPlateAppearancePickerPicked(value: AppColorScheme)

    public var designation: PrimeEventDesignation {
        switch self {
#if DEBUG
        case .observationButtonTapped:
                .observationButtonTapped
#endif
        case .appLaunched:
                .appLaunched
        case .timeElapsed:
                .timeElapsed
        case .audioSessionInterruptionBegan:
                .audioSessionInterruptionBegan
        case .audioSessionInterruptionEnded:
                .audioSessionInterruptionEnded
        case .audioSessionRouteChanged:
                .audioSessionRouteChanged
        case .audioSessionMediaServicesWereReset:
                .audioSessionMediaServicesWereReset
        case .mainPlateShareButtonTapped:
                .mainPlateShareButtonTapped
        case .mainPlateMarathonButtonTapped:
                .mainPlateMarathonButtonTapped
        case .mainPlateRankingsButtonTapped:
                .mainPlateRankingsButtonTapped
        case .mainPlateSettingsButtonTapped:
                .mainPlateSettingsButtonTapped
        case .mainPlateIdfaAuthorizationGranted:
                .mainPlateIdfaAuthorizationGranted
        case .mainPlateIdfaAuthorizationDenied:
                .mainPlateIdfaAuthorizationDenied
        case .basicGamePlateBackButtonTapped:
                .basicGamePlateBackButtonTapped
        case .basicGamePlateHowToPlayButtonTapped:
                .basicGamePlateHowToPlayButtonTapped
        case .basicGamePlateResetButtonTapped:
                .basicGamePlateResetButtonTapped
        case .basicGamePlateBeforeResetDialogResetButtonTapped:
                .basicGamePlateBeforeResetDialogResetButtonTapped
        case .basicGamePlateBeforeResetDialogCancelButtonTapped:
                .basicGamePlateBeforeResetDialogCancelButtonTapped
        case .basicGamePlateGameBoardTapped:
                .basicGamePlateGameBoardTapped
        case .basicGamePlateGameBoardDragged:
                .basicGamePlateGameBoardDragged
        case .basicGamePlateGameBoardDragEnded:
                .basicGamePlateGameBoardDragEnded
        case .basicGamePlatePlaceButtonTapped:
                .basicGamePlatePlaceButtonTapped
        case .basicGamePlateResultDialogBackButtonTapped:
                .basicGamePlateResultDialogBackButtonTapped
        case .basicGamePlateResultDialogRestartButtonTapped:
                .basicGamePlateResultDialogRestartButtonTapped
        case .basicGameTutorialPlateCloseButtonTapped:
                .basicGameTutorialPlateCloseButtonTapped
        case .basicGameTutorialPlateGameBoardTapped:
                .basicGameTutorialPlateGameBoardTapped
        case .basicGameTutorialPlateGameBoardDragged:
                .basicGameTutorialPlateGameBoardDragged
        case .basicGameTutorialPlateGameBoardDragEnded:
                .basicGameTutorialPlateGameBoardDragEnded
        case .basicGameTutorialPlatePlaceButtonTapped:
                .basicGameTutorialPlatePlaceButtonTapped
        case .basicGameTutorialPlateTutorialGuideDialogButtonTapped:
                .basicGameTutorialPlateTutorialGuideDialogButtonTapped
        case .settingsPlateCloseButtonTapped:
                .settingsPlateCloseButtonTapped
        case .settingsPlateHapticFeedbackToggleTapped:
                .settingsPlateHapticFeedbackToggleTapped
        case .settingsPlateAppearancePickerPicked:
                .settingsPlateAppearancePickerPicked
        }
    }
}
