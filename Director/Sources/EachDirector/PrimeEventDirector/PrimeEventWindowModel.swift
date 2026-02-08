// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Body

@MainActor @Observable public final class PrimeEventWindowModel {

    public static let shared = PrimeEventWindowModel(
        isVisible: false,
        thrownArray: [],
        waitingArray: [],
        performingArray: [],
        completedArray: []
    )

    public var isVisible: Bool
    public var thrownArray: [(PrimeEventDesignation, Date)]
    public var waitingArray: [PrimeEventDesignation]
    public var performingArray: [PrimeEventDesignation]
    public var completedArray: [(PrimeEventDesignation, Date)]

    private init(
        isVisible: Bool,
        thrownArray: [(PrimeEventDesignation, Date)],
        waitingArray: [PrimeEventDesignation],
        performingArray: [PrimeEventDesignation],
        completedArray: [(PrimeEventDesignation, Date)]
    ) {
        self.isVisible = isVisible
        self.thrownArray = thrownArray
        self.waitingArray = waitingArray
        self.performingArray = performingArray
        self.completedArray = completedArray
    }
}
