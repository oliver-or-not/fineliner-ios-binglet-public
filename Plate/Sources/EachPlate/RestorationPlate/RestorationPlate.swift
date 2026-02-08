// MARK: - Module Dependency

import Spectrum
import PlateBase

// MARK: - Context

@MainActor fileprivate let viewModel = RestorationPlateViewModel.shared

// MARK: - Body

extension GlobalEntity.Plate {

    public static let restorationPlate: RestorationPlateInterface = RestorationPlate()
}

public protocol RestorationPlateInterface: GlobalEntity.Plate.Interface, Sendable {}

fileprivate final actor RestorationPlate: RestorationPlateInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: PlateDesignation = .restoration

    // MARK: - State

    // MARK: - Lifecycle

    init() {}

    // MARK: - RestorationPlateInterface

    private func updateViewModel() async {}
}
