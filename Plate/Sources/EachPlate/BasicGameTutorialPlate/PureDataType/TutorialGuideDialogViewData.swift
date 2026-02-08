// MARK: - Body

struct TutorialGuideDialogViewData: Hashable, Sendable {

    var text: String?
    var buttonVariety: ButtonVariety?

    enum ButtonVariety: Hashable, Sendable {

        case ok
    }
}
