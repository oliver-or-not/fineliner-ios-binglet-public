// MARK: - Module Dependency

import Universe

// MARK: - Body

public enum SimpleLinkPlaceState: Codable, Hashable, Sendable {

    case empty
    case occupied
}

extension Matrix<SimpleLinkPlaceState> {

    public func rotated(_ quarterRotation: QuarterRotation) -> Matrix<SimpleLinkPlaceState> {
        switch quarterRotation {
        case .identity:
            return self
        case .quarter:
            let yCountBeforeRotation = self.count
            let xCountBeforeRotation: Int
            if yCountBeforeRotation > 0 {
                xCountBeforeRotation = self[0].count
            } else {
                xCountBeforeRotation = 0
            }
            let yCountAfterRotation = xCountBeforeRotation
            let xCountAfterRotation = yCountBeforeRotation
            var rotated: Matrix<SimpleLinkPlaceState> = .init(
                repeating: .init(
                    repeating: .empty,
                    count: xCountAfterRotation
                ),
                count: yCountAfterRotation
            )
            for y in 0..<yCountBeforeRotation {
                for x in 0..<xCountBeforeRotation {
                    rotated[yCountAfterRotation - 1 - x][y] = self[y][x]
                }
            }
            return rotated
        case .half:
            let yCountBeforeRotation = self.count
            let xCountBeforeRotation: Int
            if yCountBeforeRotation > 0 {
                xCountBeforeRotation = self[0].count
            } else {
                xCountBeforeRotation = 0
            }
            let yCountAfterRotation = yCountBeforeRotation
            let xCountAfterRotation = xCountBeforeRotation
            var rotated: Matrix<SimpleLinkPlaceState> = .init(
                repeating: .init(
                    repeating: .empty,
                    count: xCountAfterRotation
                ),
                count: yCountAfterRotation
            )
            for y in 0..<yCountBeforeRotation {
                for x in 0..<xCountBeforeRotation {
                    rotated[yCountAfterRotation - 1 - y][xCountAfterRotation - 1 - x] = self[y][x]
                }
            }
            return rotated
        case .threeQuarters:
            let yCountBeforeRotation = self.count
            let xCountBeforeRotation: Int
            if yCountBeforeRotation > 0 {
                xCountBeforeRotation = self[0].count
            } else {
                xCountBeforeRotation = 0
            }
            let yCountAfterRotation = xCountBeforeRotation
            let xCountAfterRotation = yCountBeforeRotation
            var rotated: Matrix<SimpleLinkPlaceState> = .init(
                repeating: .init(
                    repeating: .empty,
                    count: xCountAfterRotation
                ),
                count: yCountAfterRotation
            )
            for y in 0..<yCountBeforeRotation {
                for x in 0..<xCountBeforeRotation {
                    rotated[x][xCountAfterRotation - 1 - y] = self[y][x]
                }
            }
            return rotated
        }
    }
}
