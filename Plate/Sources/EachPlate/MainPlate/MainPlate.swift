// MARK: - Module Dependency

import Spectrum
import Director
import PlateBase

// MARK: - Context

@MainActor fileprivate let viewModel = MainPlateViewModel.shared

// MARK: - Body

extension GlobalEntity.Plate {

    public static let mainPlate: MainPlateInterface = MainPlate()
}

public protocol MainPlateInterface: GlobalEntity.Plate.Interface, Sendable {}

fileprivate final actor MainPlate: MainPlateInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: PlateDesignation = .main

    // MARK: - State

    // MARK: - Lifecycle

    init() {}

    // MARK: - MainPlateInterface
}

