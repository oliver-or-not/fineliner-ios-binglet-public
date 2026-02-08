// MARK: - Module Dependency

import Foundation

// MARK: - Body

@MainActor @Observable public final class ShareWindowModel {

    public static let shared = ShareWindowModel(
        linkString: nil,
        shareSheetPresentationRequestSignal: 0
    )

    public var linkString: String?
    public var shareSheetPresentationRequestSignal: Int

    private init(linkString: String?, shareSheetPresentationRequestSignal: Int) {
        self.linkString = linkString
        self.shareSheetPresentationRequestSignal = shareSheetPresentationRequestSignal
    }
}
