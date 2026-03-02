// MARK: - Module Dependency

import Foundation

// MARK: - Body

@MainActor @Observable public final class ShareWindowModel {

    public static let shared = ShareWindowModel(
        linkString: nil,
        shareSheetPresentationDefaultRequestSignal: 0,
        shareSheetPresentationRequestWithScoreSignal: (0, 0)
    )

    public var linkString: String?
    public var shareSheetPresentationDefaultRequestSignal: Int
    public var shareSheetPresentationRequestWithScoreSignal: (Int, Int) // (시그널 카운터, 스코어)

    private init(linkString: String?, shareSheetPresentationDefaultRequestSignal: Int, shareSheetPresentationRequestWithScoreSignal: (Int, Int)) {
        self.linkString = linkString
        self.shareSheetPresentationDefaultRequestSignal = shareSheetPresentationDefaultRequestSignal
        self.shareSheetPresentationRequestWithScoreSignal = shareSheetPresentationRequestWithScoreSignal
    }
}
