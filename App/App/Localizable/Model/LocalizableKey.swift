// MARK: - Module Dependency

import Foundation

// MARK: - Body

enum LocalizableKey {

    case defaultShareContent
    case shareContentWithScore(score: Int)
}

extension LocalizableKey {

    var localizationValue: String.LocalizationValue {
        switch self {
        case .defaultShareContent:
            return "default-share-content"
        case .shareContentWithScore(let score):
            return "share-content-with-score \(score)"
        }
    }
}
