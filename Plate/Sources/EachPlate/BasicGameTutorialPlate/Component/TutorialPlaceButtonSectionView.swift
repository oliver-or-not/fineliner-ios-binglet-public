// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

struct TutorialPlaceButtonSectionView: View {

    let viewData: PlaceButtonViewData
    let highlightState: TutorialHighlightState?

    var body: some View {
        Group {
            switch viewData {
            case .disabled:
                Button {
                    _ = 0
                } label: {
                    ZStack {
                        Capsule()
                            .fill(DS.SemanticColor.disabledInteractable)
                            .frame(width: 120, height: 60)
                        DS.SymbolImage.arrowDownAppDashed
                            .font(.system(size: 25))
                            .foregroundStyle(DS.SemanticColor.disabledText)
                    }
                }
            case .enabled:
                Button {
                    if highlightState == .placeButton {
                        Task {
                            guard highlightState == .placeButton else { return }
                            await primeEventDirector.receive(
                                .basicGameTutorialPlatePlaceButtonTapped
                            )
                        }
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(DS.SemanticColor.interactable)
                            .frame(width: 120, height: 60)
                        DS.SymbolImage.arrowDownAppDashed
                            .font(.system(size: 25))
                            .foregroundStyle(DS.SemanticColor.generalText)
                    }
                }
            }
        }
        .frame(height: 60)
    }
}

#Preview {
    TutorialPlaceButtonSectionView(viewData: .disabled, highlightState: .placeButton)
}
