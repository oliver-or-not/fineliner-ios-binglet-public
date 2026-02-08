// MARK: - Body

extension TutorialGuideDialogViewData.ButtonVariety {

    var text: String {
        switch self {
        case .ok:
            String(lKey: .basicGameTutorialPlateTutorialGuideDialogOkButtonTitle)
        }
    }
}
