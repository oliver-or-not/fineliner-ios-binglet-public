// MARK: - Module Dependency

import Universe
import Spectrum

// MARK: - Body

extension ActiveBingletProcessData.AccumulatedPlacingChoice {

    var rotation: QuarterRotation {
        let normalizedCount = ((rotationCount % 4) + 4) % 4
        return switch normalizedCount {
        case 0:
                .identity
        case 1:
                .quarter
        case 2:
                .half
        case 3:
                .threeQuarters
        default:
                .identity
        }
    }

    func toPlacingChoice() -> ActiveBingletProcessData.PlacingChoice {
        ActiveBingletProcessData.PlacingChoice(rotation: rotation, gridOffset: gridOffset)
    }
}
