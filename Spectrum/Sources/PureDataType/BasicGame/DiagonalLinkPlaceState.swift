// MARK: - Module Dependency

import Universe

// MARK: - Body

public enum DiagonalLinkPlaceState: Codable, Hashable, Sendable {

    case empty
    case slash
    case backslash
    case cross
}

extension DiagonalLinkPlaceState {

    public func plus(_ state: DiagonalLinkPlaceState) -> DiagonalLinkPlaceState {
        switch (self, state) {
        case (.empty, .empty):
                .empty
        case (.empty, .slash):
                .slash
        case (.empty, .backslash):
                .backslash
        case (.empty, .cross):
                .cross
        case (.slash, .empty):
                .slash
        case (.slash, .slash):
                .slash
        case (.slash, .backslash):
                .cross
        case (.slash, .cross):
                .cross
        case (.backslash, .empty):
                .backslash
        case (.backslash, .slash):
                .cross
        case (.backslash, .backslash):
                .backslash
        case (.backslash, .cross):
                .cross
        case (.cross, .empty):
                .cross
        case (.cross, .slash):
                .cross
        case (.cross, .backslash):
                .cross
        case (.cross, .cross):
                .cross
        }
    }

    public func minus(_ state: DiagonalLinkPlaceState) -> DiagonalLinkPlaceState {
        switch (self, state) {
        case (.empty, .empty):
                .empty
        case (.empty, .slash):
                .empty
        case (.empty, .backslash):
                .empty
        case (.empty, .cross):
                .empty
        case (.slash, .empty):
                .slash
        case (.slash, .slash):
                .empty
        case (.slash, .backslash):
                .slash
        case (.slash, .cross):
                .empty
        case (.backslash, .empty):
                .backslash
        case (.backslash, .slash):
                .backslash
        case (.backslash, .backslash):
                .empty
        case (.backslash, .cross):
                .empty
        case (.cross, .empty):
                .cross
        case (.cross, .slash):
                .backslash
        case (.cross, .backslash):
                .slash
        case (.cross, .cross):
                .empty
        }
    }
}

extension Matrix<DiagonalLinkPlaceState> {

    public func rotated(_ quarterRotation: QuarterRotation) -> Matrix<DiagonalLinkPlaceState> {
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
            var rotated: Matrix<DiagonalLinkPlaceState> = .init(
                repeating: .init(
                    repeating: .empty,
                    count: xCountAfterRotation
                ),
                count: yCountAfterRotation
            )
            for y in 0..<yCountBeforeRotation {
                for x in 0..<xCountBeforeRotation {
                    switch self[y][x] {
                    case .empty:
                        rotated[yCountAfterRotation - 1 - x][y] = .empty
                    case .slash:
                        rotated[yCountAfterRotation - 1 - x][y] = .backslash
                    case .backslash:
                        rotated[yCountAfterRotation - 1 - x][y] = .slash
                    case .cross:
                        rotated[yCountAfterRotation - 1 - x][y] = .cross
                    }
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
            var rotated: Matrix<DiagonalLinkPlaceState> = .init(
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
            var rotated: Matrix<DiagonalLinkPlaceState> = .init(
                repeating: .init(
                    repeating: .empty,
                    count: xCountAfterRotation
                ),
                count: yCountAfterRotation
            )
            for y in 0..<yCountBeforeRotation {
                for x in 0..<xCountBeforeRotation {
                    switch self[y][x] {
                    case .empty:
                        rotated[x][xCountAfterRotation - 1 - y] = .empty
                    case .slash:
                        rotated[x][xCountAfterRotation - 1 - y] = .backslash
                    case .backslash:
                        rotated[x][xCountAfterRotation - 1 - y] = .slash
                    case .cross:
                        rotated[x][xCountAfterRotation - 1 - y] = .cross
                    }
                }
            }
            return rotated
        }
    }
}
