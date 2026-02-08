// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Director
import PlateBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

public struct RestorationPlateView: View {

    // MARK: - Reference

    @Bindable private var viewModel: RestorationPlateViewModel

    // MARK: - Constant

    // MARK: - State

    // MARK: - Lifecycle

    public init() {
        self.viewModel = .shared
    }

    init(viewModel: RestorationPlateViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            DS.SemanticColor.generalBackground
                .ignoresSafeArea()
            DSCircularLoadingView(color: DS.SemanticColor.generalLoading)
        }
    }
}
