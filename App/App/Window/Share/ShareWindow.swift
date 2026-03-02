// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Agent
import Plate

// MARK: - Body

struct ShareWindow: View {

    // MARK: - Reference

    @Bindable var windowModel: ShareWindowModel

    // MARK: - Constant

    // MARK: - State

    @State private var presenter: UIViewController?
    @State private var shareVc: UIActivityViewController?

    // MARK: - View

    var body: some View {
        ZStack {
            ViewControllerPresenter { presenter = $0 }
                .frame(width: 0, height: 0)
        }
        .onChange(of: windowModel.shareSheetPresentationDefaultRequestSignal) { _, _ in
            defaultPresent()
        }
        .onChange(of: windowModel.shareSheetPresentationRequestWithScoreSignal.0) { _, _ in
            presentWithScore(score: windowModel.shareSheetPresentationRequestWithScoreSignal.1)
        }
    }

    @MainActor
    private func defaultPresent() {
        guard let presenter, shareVc == nil else { return }

        let shareText: String
        = String(lKey: .defaultShareContent)
        + "\n"
        + (windowModel.linkString ?? "")

        let vc = UIActivityViewController(
            activityItems: [
                shareText,
            ],
            applicationActivities: nil
        )

        vc.completionWithItemsHandler = { _, _, _, _ in
            Task { @MainActor in
                shareVc = nil
            }
        }

        shareVc = vc
        presenter.present(vc, animated: true)
    }

    @MainActor
    private func presentWithScore(score: Int) {
        guard let presenter, shareVc == nil else { return }

        let shareText: String
        = String(lKey: .shareContentWithScore(score: score))
        + "\n"
        + (windowModel.linkString ?? "")

        let vc = UIActivityViewController(
            activityItems: [
                shareText,
            ],
            applicationActivities: nil
        )

        vc.completionWithItemsHandler = { _, _, _, _ in
            Task { @MainActor in
                shareVc = nil
            }
        }

        shareVc = vc
        presenter.present(vc, animated: true)
    }
}
