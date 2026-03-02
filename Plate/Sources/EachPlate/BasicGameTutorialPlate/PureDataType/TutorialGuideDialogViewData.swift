// MARK: - Body

struct TutorialGuideDialogViewData: Hashable, Sendable {

    var text: String?
    var buttonVariety: ButtonVariety?
    var hasBackgroundDim: Bool

    enum ButtonVariety: Hashable, Sendable {

        case ok
    }
}
