// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

enum BasicGamePlateLogic {

    static func getMultiplicationValue(comboCount: UInt) -> Int {
        Int((comboCount + 1) * (comboCount + 2) / 2)
    }

    static func getNewGridOffset(
        translation: CGSize,
        gridOffsetWhenDragBegan: GridVector,
        currentGridOffset: GridVector,
        binglet: Binglet,
        rotation: QuarterRotation,
        unitDistance: CGFloat
    ) -> GridVector {
        let gridOffsetDifferenceWhileDragging = currentGridOffset - gridOffsetWhenDragBegan
        let residualTranslation = CGPoint(
            x: translation.width - CGFloat(gridOffsetDifferenceWhileDragging.x) * unitDistance,
            y: translation.height - CGFloat(gridOffsetDifferenceWhileDragging.y) * unitDistance
        )
        guard abs(residualTranslation.x) > unitDistance * Constant.gridOffsetPreservingRatio
            || abs(residualTranslation.y) > unitDistance * Constant.gridOffsetPreservingRatio else {
            // 일정 거리 이상 떨어지지 않으면 현재의 grid offset을 유지한다.
            return currentGridOffset
        }
        let newGridOffsetXWithoutConsideringGameBoardBoundary
        = gridOffsetWhenDragBegan.x + Int(round(translation.width / unitDistance))
        let newGridOffsetYWithoutConsideringGameBoardBoundary
        = gridOffsetWhenDragBegan.y + Int(round(translation.height / unitDistance))

        let minimalGridOffsetX = getMinimalGridOffsetX(binglet: binglet, rotation: rotation)
        let maximalGridOffsetX = getMaximalGridOffsetX(binglet: binglet, rotation: rotation)
        let minimalGridOffsetY = getMinimalGridOffsetY(binglet: binglet, rotation: rotation)
        let maximalGridOffsetY = getMaximalGridOffsetY(binglet: binglet, rotation: rotation)

        let newGridOffsetX = min(
            max(
                minimalGridOffsetX,
                newGridOffsetXWithoutConsideringGameBoardBoundary
            ),
            maximalGridOffsetX
        )
        let newGridOffsetY = min(
            max(
                minimalGridOffsetY,
                newGridOffsetYWithoutConsideringGameBoardBoundary
            ),
            maximalGridOffsetY
        )
        return GridVector(x: newGridOffsetX, y: newGridOffsetY)
    }

    static func getMinimalGridOffsetX(binglet: Binglet, rotation: QuarterRotation) -> Int {
        let additionalValue: UInt
        switch rotation {
        case .identity:
            additionalValue = binglet.leftEmptyRowCount
        case .quarter:
            additionalValue = binglet.topEmptyRowCount
        case .half:
            additionalValue = binglet.rightEmptyRowCount
        case .threeQuarters:
            additionalValue = binglet.bottomEmptyRowCount
        }
        return -(Constant.gameBoardHorizontalNodeCount - Constant.bingletContainerHorizontalNodeCount) / 2
        - Int(additionalValue)
    }

    static func getMaximalGridOffsetX(binglet: Binglet, rotation: QuarterRotation) -> Int {
        let additionalValue: UInt
        switch rotation {
        case .identity:
            additionalValue = binglet.rightEmptyRowCount
        case .quarter:
            additionalValue = binglet.bottomEmptyRowCount
        case .half:
            additionalValue = binglet.leftEmptyRowCount
        case .threeQuarters:
            additionalValue = binglet.topEmptyRowCount
        }
        return (Constant.gameBoardHorizontalNodeCount - Constant.bingletContainerHorizontalNodeCount) / 2
        + Int(additionalValue)
    }

    static func getMinimalGridOffsetY(binglet: Binglet, rotation: QuarterRotation) -> Int {
        let additionalValue: UInt
        switch rotation {
        case .identity:
            additionalValue = binglet.topEmptyRowCount
        case .quarter:
            additionalValue = binglet.rightEmptyRowCount
        case .half:
            additionalValue = binglet.bottomEmptyRowCount
        case .threeQuarters:
            additionalValue = binglet.leftEmptyRowCount
        }
        return -(Constant.gameBoardVerticalNodeCount - Constant.bingletContainerVerticalNodeCount) / 2
        - Int(additionalValue)
    }

    static func getMaximalGridOffsetY(binglet: Binglet, rotation: QuarterRotation) -> Int {
        let additionalValue: UInt
        switch rotation {
        case .identity:
            additionalValue = binglet.bottomEmptyRowCount
        case .quarter:
            additionalValue = binglet.leftEmptyRowCount
        case .half:
            additionalValue = binglet.topEmptyRowCount
        case .threeQuarters:
            additionalValue = binglet.rightEmptyRowCount
        }
        return (Constant.gameBoardVerticalNodeCount - Constant.bingletContainerVerticalNodeCount) / 2
        + Int(additionalValue)
    }

    static func getDuplicatableGameBoardDataWithPlacedBinglet(
        gameBoardData: GameBoardData,
        binglet: Binglet,
        placingChoice: ActiveBingletProcessData.PlacingChoice
    ) -> DuplicatableGameBoardData {
        var duplicatableGameBoardDataWithPlacedBinglet = DuplicatableGameBoardData(
            nodePlaceDataMatrix: gameBoardData.nodePlaceDataMatrix.map { row in
                row.map { nodePlaceData in
                    if let occupiedNodeData = nodePlaceData.occupiedNodeData {
                        return .singleOccupied(
                            NodeData(
                                origin: occupiedNodeData.origin,
                                comboCount: occupiedNodeData.comboCount
                            )
                        )
                    } else {
                        return .empty
                    }
                }
            },
            horizontalLinkMatrix: gameBoardData.horizontalLinkMatrix,
            verticalLinkMatrix: gameBoardData.verticalLinkMatrix,
            diagonalLinkMatrix: gameBoardData.diagonalLinkMatrix
        )

        let bingletRotatedNodeMatrix = binglet.nodeMatrix.rotated(placingChoice.rotation)
        for y in 0..<bingletRotatedNodeMatrix.count {
            for x in 0..<bingletRotatedNodeMatrix[0].count {
                let matchingPoint = getOverlappingPointInGameBoard(
                    pointInBingletContainer: GridVector(x: x, y: y),
                    placingChoiceOffset: placingChoice.gridOffset
                )
                guard 0<=matchingPoint.x, matchingPoint.x<Constant.gameBoardHorizontalNodeCount,
                      0<=matchingPoint.y, matchingPoint.y<Constant.gameBoardVerticalNodeCount else {
                    continue
                }
                switch bingletRotatedNodeMatrix[y][x] {
                case .empty:
                    _ = 0
                case .occupied:
                    if gameBoardData.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x].occupiedNodeData != nil {
                        duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x] = .duplicated
                    } else {
                        duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x] = .singleOccupied(NodeData(origin: binglet, comboCount: 0))
                    }
                }
            }
        }

        let bingletRotatedHorizontalLinkMatrix: Matrix<SimpleLinkPlaceState>
        switch placingChoice.rotation {
        case .identity:
            bingletRotatedHorizontalLinkMatrix = binglet.horizontalLinkMatrix
        case .quarter:
            bingletRotatedHorizontalLinkMatrix = binglet.verticalLinkMatrix.rotated(.quarter)
        case .half:
            bingletRotatedHorizontalLinkMatrix = binglet.horizontalLinkMatrix.rotated(.half)
        case .threeQuarters:
            bingletRotatedHorizontalLinkMatrix = binglet.verticalLinkMatrix.rotated(.threeQuarters)
        }
        for y in 0..<bingletRotatedHorizontalLinkMatrix.count {
            for x in 0..<bingletRotatedHorizontalLinkMatrix[0].count {
                let matchingPoint = getOverlappingPointInGameBoard(
                    pointInBingletContainer: GridVector(x: x, y: y),
                    placingChoiceOffset: placingChoice.gridOffset
                )
                guard 0<=matchingPoint.x, matchingPoint.x<Constant.gameBoardHorizontalNodeCount - 1,
                      0<=matchingPoint.y, matchingPoint.y<Constant.gameBoardVerticalNodeCount else {
                    continue
                }
                switch bingletRotatedHorizontalLinkMatrix[y][x] {
                case .empty:
                    _ = 0
                case .occupied:
                    if duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x] != .empty
                    && duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x + 1] != .empty {
                        duplicatableGameBoardDataWithPlacedBinglet.horizontalLinkMatrix[matchingPoint.y][matchingPoint.x] = .occupied
                    }
                }
            }
        }

        let bingletRotatedVerticalLinkMatrix: Matrix<SimpleLinkPlaceState>
        switch placingChoice.rotation {
        case .identity:
            bingletRotatedVerticalLinkMatrix = binglet.verticalLinkMatrix
        case .quarter:
            bingletRotatedVerticalLinkMatrix = binglet.horizontalLinkMatrix.rotated(.quarter)
        case .half:
            bingletRotatedVerticalLinkMatrix = binglet.verticalLinkMatrix.rotated(.half)
        case .threeQuarters:
            bingletRotatedVerticalLinkMatrix = binglet.horizontalLinkMatrix.rotated(.threeQuarters)
        }
        for y in 0..<bingletRotatedVerticalLinkMatrix.count {
            for x in 0..<bingletRotatedVerticalLinkMatrix[0].count {
                let matchingPoint = getOverlappingPointInGameBoard(
                    pointInBingletContainer: GridVector(x: x, y: y),
                    placingChoiceOffset: placingChoice.gridOffset
                )
                guard 0<=matchingPoint.x, matchingPoint.x<Constant.gameBoardHorizontalNodeCount,
                      0<=matchingPoint.y, matchingPoint.y<Constant.gameBoardVerticalNodeCount - 1 else {
                    continue
                }
                switch bingletRotatedVerticalLinkMatrix[y][x] {
                case .empty:
                    _ = 0
                case .occupied:
                    if duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y + 1][matchingPoint.x] != .empty
                    && duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x] != .empty {
                        duplicatableGameBoardDataWithPlacedBinglet.verticalLinkMatrix[matchingPoint.y][matchingPoint.x] = .occupied
                    }
                }
            }
        }

        let bingletRotatedDiagonalLinkMatrix = binglet.diagonalLinkMatrix.rotated(placingChoice.rotation)
        for y in 0..<bingletRotatedDiagonalLinkMatrix.count {
            for x in 0..<bingletRotatedDiagonalLinkMatrix[0].count {
                let matchingPoint = getOverlappingPointInGameBoard(
                    pointInBingletContainer: GridVector(x: x, y: y),
                    placingChoiceOffset: placingChoice.gridOffset
                )
                guard 0<=matchingPoint.x, matchingPoint.x<Constant.gameBoardHorizontalNodeCount - 1,
                      0<=matchingPoint.y, matchingPoint.y<Constant.gameBoardVerticalNodeCount - 1 else {
                    continue
                }
                let isSlashValid = duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y + 1][matchingPoint.x] != .empty
                && duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x + 1] != .empty
                let isBackslashValid = duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y][matchingPoint.x] != .empty
                && duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[matchingPoint.y + 1][matchingPoint.x + 1] != .empty
                switch bingletRotatedDiagonalLinkMatrix[y][x] {
                case .empty:
                    _ = 0
                case .slash:
                    if isSlashValid {
                        duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x]
                        = gameBoardData.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x].plus(.slash)
                    }
                case .backslash:
                    if isBackslashValid {
                        duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x]
                        = gameBoardData.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x].plus(.backslash)
                    }
                case .cross:
                    switch (isSlashValid, isBackslashValid) {
                    case (true, true):
                        duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x]
                        = gameBoardData.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x].plus(.cross)
                    case (true, false):
                        duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x]
                        = gameBoardData.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x].plus(.slash)
                    case (false, true):
                        duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x]
                        = gameBoardData.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x].plus(.backslash)
                    case (false, false):
                        duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x]
                        = gameBoardData.diagonalLinkMatrix[matchingPoint.y][matchingPoint.x].plus(.empty)
                    }
                }
            }
        }

        return duplicatableGameBoardDataWithPlacedBinglet
    }

    static func getOverlappingPointInGameBoard(
        pointInBingletContainer: GridVector,
        placingChoiceOffset: GridVector
    ) -> GridVector {
        let x = Constant.gameBoardHorizontalNodeCount / 2
        - Constant.bingletContainerHorizontalNodeCount / 2
        + pointInBingletContainer.x
        + placingChoiceOffset.x
        let y = Constant.gameBoardVerticalNodeCount / 2
        - Constant.bingletContainerVerticalNodeCount / 2
        + pointInBingletContainer.y
        + placingChoiceOffset.y
        return GridVector(x: x, y: y)
    }

    static func getGameBoardHintData(
        gameBoardData: GameBoardData,
        binglet: Binglet,
        placingChoice: ActiveBingletProcessData.PlacingChoice,
        duplicatableGameBoardDataWithPlacedBinglet: DuplicatableGameBoardData
    ) -> GameBoardHintData {
        let emptyNotPlaceableNodePlaceDataMatrix: Matrix<GameBoardHintData.NotPlaceableData.NodePlaceData> = Array(
            repeating: Array(
                repeating: .empty,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        var notPlaceableNodePlaceDataMatrix = emptyNotPlaceableNodePlaceDataMatrix
        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                switch duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[y][x] {
                case .duplicated:
                    notPlaceableNodePlaceDataMatrix[y][x] = .illegal
                case .singleOccupied:
                    if gameBoardData.nodePlaceDataMatrix[y][x].occupiedNodeData == nil
                        && gameBoardData.nodePlaceDataMatrix[y][x].blockState == .blocked {
                        notPlaceableNodePlaceDataMatrix[y][x] = .illegal
                    }
                default:
                    _ = 0
                }
            }
        }
        guard notPlaceableNodePlaceDataMatrix == emptyNotPlaceableNodePlaceDataMatrix else {
            return .notPlaceable(GameBoardHintData.NotPlaceableData(nodePlaceDataMatrix: notPlaceableNodePlaceDataMatrix))
        }

        var nodePlaceDataMatrix: Matrix<GameBoardHintData.PlaceableData.NodePlaceData> = Array(
            repeating: Array(
                repeating: .empty,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        var horizontalLinkPlaceDataMatrix: Matrix<GameBoardHintData.PlaceableData.SimpleLinkPlaceData> = Array(
            repeating: Array(
                repeating: .empty,
                count: Constant.gameBoardHorizontalNodeCount - 1
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        var verticalLinkPlaceDataMatrix: Matrix<GameBoardHintData.PlaceableData.SimpleLinkPlaceData> = Array(
            repeating: Array(
                repeating: .empty,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount - 1
        )
        var diagonalLinkPlaceDataMatrix: Matrix<GameBoardHintData.PlaceableData.DiagonalLinkPlaceData> = Array(
            repeating: Array(
                repeating: .empty,
                count: Constant.gameBoardHorizontalNodeCount - 1
            ),
            count: Constant.gameBoardVerticalNodeCount - 1
        )
        var leadingComboCount: UInt = 0

        let bingles = getBingles(duplicatableGameBoardData: duplicatableGameBoardDataWithPlacedBinglet)
        var combinedNodeHomologyClassMatrix: [[NodeHomologyClass]] = Array(
            repeating: Array(
                repeating: .outside,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )

        for bingle in bingles {
            let nodeHomologyClassMatrix = getNodeHomologyClassMatrix(bingle)
            for y in 0..<Constant.gameBoardVerticalNodeCount {
                for x in 0..<Constant.gameBoardHorizontalNodeCount {
                    let nodeHomologyClass = nodeHomologyClassMatrix[y][x]
                    switch nodeHomologyClass {
                    case .outside:
                        _ = 0
                    case .inside:
                        if combinedNodeHomologyClassMatrix[y][x] == .outside {
                            combinedNodeHomologyClassMatrix[y][x] = .inside
                        }
                    case .boundary:
                        combinedNodeHomologyClassMatrix[y][x] = .boundary
                    }
                }
            }
        }

        for bingle in bingles {
            guard let firstInBingle = bingle.first else { continue }
            let headAppendedBingle = bingle + [firstInBingle]
            for i in 0..<(headAppendedBingle.count - 1) {
                let edgeStartPoint = headAppendedBingle[i]
                let edgeEndPoint = headAppendedBingle[i + 1]
                let unitDirection = getUnitDirection(from: edgeStartPoint, to: edgeEndPoint)
                switch unitDirection {
                case .right:
                    horizontalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x] = .expectedToFormBingle
                case .upRight:
                    diagonalLinkPlaceDataMatrix[edgeStartPoint.y - 1][edgeStartPoint.x]
                    = diagonalLinkPlaceDataMatrix[edgeStartPoint.y - 1][edgeStartPoint.x].plus(.expectedToFormBingleWithSlash)
                case .up:
                    verticalLinkPlaceDataMatrix[edgeStartPoint.y - 1][edgeStartPoint.x] = .expectedToFormBingle
                case .upLeft:
                    diagonalLinkPlaceDataMatrix[edgeStartPoint.y - 1][edgeStartPoint.x - 1]
                    = diagonalLinkPlaceDataMatrix[edgeStartPoint.y - 1][edgeStartPoint.x - 1].plus(.expectedToFormBingleWithBackslash)
                case .left:
                    horizontalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x - 1] = .expectedToFormBingle
                case .downLeft:
                    diagonalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x - 1]
                    = diagonalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x - 1].plus(.expectedToFormBingleWithSlash)
                case .down:
                    verticalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x] = .expectedToFormBingle
                case .downRight:
                    diagonalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x]
                    = diagonalLinkPlaceDataMatrix[edgeStartPoint.y][edgeStartPoint.x].plus(.expectedToFormBingleWithBackslash)
                case nil:
                    _ = 0
                }
            }
        }

        for bingle in bingles {
            for point in bingle {
                switch duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[point.y][point.x] {
                case .singleOccupied(let nodeData):
                    leadingComboCount = max(leadingComboCount, nodeData.comboCount)
                default:
                    _ = 0
                }
            }
        }

        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                switch combinedNodeHomologyClassMatrix[y][x] {
                case .outside:
                    nodePlaceDataMatrix[y][x] = .empty
                case .inside:
                    nodePlaceDataMatrix[y][x] = .insideBingleRegion
                case .boundary:
                    switch duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[y][x] {
                    case .singleOccupied(let singleOccupiedData):
                        nodePlaceDataMatrix[y][x] = .expectedToFormBingle(
                            comboCount: singleOccupiedData.comboCount,
                            hasLeadingComboCount: singleOccupiedData.comboCount == leadingComboCount
                        )
                    default:
                        // 실행되기를 기대하지 않는 케이스.
                        nodePlaceDataMatrix[y][x] = .expectedToFormBingle(
                            comboCount: 0,
                            hasLeadingComboCount: false
                        )
                    }
                }
            }
        }

        return .placeable(GameBoardHintData.PlaceableData(
            nodePlaceDataMatrix: nodePlaceDataMatrix,
            horizontalLinkPlaceDataMatrix: horizontalLinkPlaceDataMatrix,
            verticalLinkPlaceDataMatrix: verticalLinkPlaceDataMatrix,
            diagonalLinkPlaceDataMatrix: diagonalLinkPlaceDataMatrix
        ))
    }

    static func getBingles(duplicatableGameBoardData: DuplicatableGameBoardData) -> [[GridVector]] {
        var connectedNodeLinearIndexArrayMemory: [[Int]] = Array(
            repeating: [],
            count: Constant.gameBoardHorizontalNodeCount * Constant.gameBoardVerticalNodeCount
        )
        for linearIndex in 0..<(Constant.gameBoardHorizontalNodeCount * Constant.gameBoardVerticalNodeCount) {
            connectedNodeLinearIndexArrayMemory[linearIndex] = duplicatableGameBoardData.getConnectedNodeLinearIndexArray(linearIndex)
        }
        var bingles: [[GridVector]] = []
        for minimalIndex in 0..<(Constant.gameBoardHorizontalNodeCount * Constant.gameBoardVerticalNodeCount) {
            var stack: [(Int, [Int], BitMask256)] = {
                var mask = BitMask256()
                mask.insert(minimalIndex)
                return [(minimalIndex, [minimalIndex], mask)]
            }()
            while let (lastVisited, path, visitedMask) = stack.popLast() {
                for visiting in connectedNodeLinearIndexArrayMemory[lastVisited] {
                    if visiting == minimalIndex && path.count >= 3 {
                        bingles.append((path + [visiting]).map { $0.toGridVector() })
                    } else if !visitedMask.contains(visiting) && visiting > minimalIndex {
                        stack.append((
                            visiting,
                            path + [visiting],
                            visitedMask.inserting(visiting)
                        ))
                    }
                }
            }
        }
        return bingles
    }

    static func getNodeHomologyClassMatrix(_ bingle: [GridVector]) -> [[NodeHomologyClass]] {
        var cycle = bingle
        guard let firstInCycle = cycle.first else {
            return Array(
                repeating: Array(
                    repeating: .outside,
                    count: Constant.gameBoardHorizontalNodeCount
                ),
                count: Constant.gameBoardVerticalNodeCount
            )
        }

        // 1) 첫 노드를 마지막에 추가
        cycle.append(firstInCycle)

        // 2) winding count grid
        var winding = Array(
            repeating: Array(
                repeating: 0,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )

        // 3) cycle node marking
        var isOn = Array(
            repeating: Array(
                repeating: false,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        for v in cycle {
            isOn[v.y][v.x] = true
        }

        // 4) 모든 edge 순회
        for i in 0..<(cycle.count - 1) {

            let A = cycle[i]
            let B = cycle[i+1]

            let ax=A.x, ay=A.y
            let bx=B.x, by=B.y

            // ---- horizontal movement = no winding
            if ay == by { continue }

            // ─────────────────────────────────────────────
            // ↓ DOWNWARD edge (ay < by)
            if ay < by {
                // 해당 y-range를 sweep
                for x in 0..<ax {
                    winding[ay][x] += 1
                }
            }
            // ↑ UPWARD edge (ay > by)
            else if ay > by {
                for x in 0..<bx {
                    winding[by][x] -= 1
                }
            }
        }

        // 5) 최종 결과 3-state 변환
        var result: [[NodeHomologyClass]] = Array(
            repeating: Array(
                repeating: .outside,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                if isOn[y][x] { result[y][x] = .boundary }
                else if winding[y][x] != 0 { result[y][x] = .inside }
                else { result[y][x] = .outside }
            }
        }

        return result
    }

    static func getUnitDirection(from startVector: GridVector, to endVector: GridVector) -> OctaDirection? {
        switch (endVector.x - startVector.x, endVector.y - startVector.y) {
        case (1, 0):
                .right
        case (1, -1):
                .upRight
        case (0, -1):
                .up
        case (-1, -1):
                .upLeft
        case (-1, 0):
                .left
        case (-1, 1):
                .downLeft
        case (0, 1):
                .down
        case (1, 1):
                .downRight
        default:
            nil
        }
    }

    static func getResolvedGameBoardData(
        gameBoardData: GameBoardData,
        binglet: Binglet,
        placingChoice: ActiveBingletProcessData.PlacingChoice,
        duplicatableGameBoardDataWithPlacedBinglet: DuplicatableGameBoardData,
        gameBoardHintData: GameBoardHintData
    ) -> GameBoardData? {
        guard case .placeable(let placeableData) = gameBoardHintData else {
            return nil
        }
        var nodePlaceDataMatrix: Matrix<GameBoardData.NodePlaceData> = Array(
            repeating: Array(
                repeating: GameBoardData.NodePlaceData(
                    blockState: .notBlocked,
                    occupiedNodeData: nil
                ),
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                switch duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[y][x] {
                case .empty:
                    nodePlaceDataMatrix[y][x] = GameBoardData.NodePlaceData(
                        blockState: gameBoardData.nodePlaceDataMatrix[y][x].blockState,
                        occupiedNodeData: nil
                    )
                case .singleOccupied(let nodeData):
                    nodePlaceDataMatrix[y][x] = GameBoardData.NodePlaceData(
                        blockState: gameBoardData.nodePlaceDataMatrix[y][x].blockState,
                        occupiedNodeData: NodeData(
                            origin: nodeData.origin,
                            comboCount: nodeData.comboCount
                        )
                    )
                case .duplicated:
                    // 도달할 수 없는 case.
                    _ = 0
                }
            }
        }
        var horizontalLinkMatrix = duplicatableGameBoardDataWithPlacedBinglet.horizontalLinkMatrix
        var verticalLinkMatrix = duplicatableGameBoardDataWithPlacedBinglet.verticalLinkMatrix
        var diagonalLinkMatrix = duplicatableGameBoardDataWithPlacedBinglet.diagonalLinkMatrix

        var isThereBingle: Bool = false
        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                switch placeableData.nodePlaceDataMatrix[y][x] {
                case .empty:
                    _ = 0
                case .insideBingleRegion:
                    _ = 0
                case .expectedToFormBingle:
                    isThereBingle = true
                }
            }
        }

        if isThereBingle {
            for y in 0..<Constant.gameBoardVerticalNodeCount {
                for x in 0..<Constant.gameBoardHorizontalNodeCount {
                    switch placeableData.nodePlaceDataMatrix[y][x] {
                    case .empty:
                        _ = 0
                    case .insideBingleRegion:
                        nodePlaceDataMatrix[y][x].occupiedNodeData?.comboCount += 1
                    case .expectedToFormBingle:
                        nodePlaceDataMatrix[y][x] = GameBoardData.NodePlaceData(
                            blockState: nodePlaceDataMatrix[y][x].blockState,
                            occupiedNodeData: nil
                        )
                    }
                }
            }
        }

        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount - 1 {
                if nodePlaceDataMatrix[y][x].occupiedNodeData == nil
                    || nodePlaceDataMatrix[y][x + 1].occupiedNodeData == nil {
                    horizontalLinkMatrix[y][x] = .empty
                }
            }
        }

        for y in 0..<Constant.gameBoardVerticalNodeCount - 1 {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                if nodePlaceDataMatrix[y][x].occupiedNodeData == nil
                    || nodePlaceDataMatrix[y + 1][x].occupiedNodeData == nil {
                    verticalLinkMatrix[y][x] = .empty
                }
            }
        }

        for y in 0..<Constant.gameBoardVerticalNodeCount - 1 {
            for x in 0..<Constant.gameBoardHorizontalNodeCount - 1 {
                if nodePlaceDataMatrix[y + 1][x].occupiedNodeData == nil
                    || nodePlaceDataMatrix[y][x + 1].occupiedNodeData == nil {
                    diagonalLinkMatrix[y][x] = diagonalLinkMatrix[y][x].minus(.slash)
                }
                if nodePlaceDataMatrix[y][x].occupiedNodeData == nil
                    || nodePlaceDataMatrix[y + 1][x + 1].occupiedNodeData == nil {
                    diagonalLinkMatrix[y][x] = diagonalLinkMatrix[y][x].minus(.backslash)
                }
            }
        }

        return GameBoardData(
            nodePlaceDataMatrix: nodePlaceDataMatrix,
            horizontalLinkMatrix: horizontalLinkMatrix,
            verticalLinkMatrix: verticalLinkMatrix,
            diagonalLinkMatrix: diagonalLinkMatrix
        )
    }

    static func getEarnedScore(
        bingledNodeCount: UInt,
        leadingComboCount: UInt
    ) -> Int {
        let multiplicationValue = getMultiplicationValue(comboCount: leadingComboCount)
        return Constant.earnedScorePerNode * Int(bingledNodeCount) * multiplicationValue
    }

    static func getBlockUpdatedGameBoardData(
        gameBoardDataBeforeBlockUpdate: GameBoardData,
        bingletPlacingCount: UInt
    ) -> GameBoardData {
        var gameBoardData = gameBoardDataBeforeBlockUpdate
        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                switch gameBoardDataBeforeBlockUpdate.nodePlaceDataMatrix[y][x].blockState {
                case .willBeBlocked(let bingletPlacingCountToBeBlocked):
                    if bingletPlacingCount < bingletPlacingCountToBeBlocked {
                        _ = 0
                    } else {
                        gameBoardData.nodePlaceDataMatrix[y][x].blockState = .blocked
                    }
                default:
                    _ = 0
                }
            }
        }
        if bingletPlacingCount % Constant.nodePlaceBlockPeriod
            == Constant.nodePlaceBlockPeriod - Constant.nodePlaceBlockStartCount {
            let gridVectorToBeBlocked = getGridVectorToBeBlocked(bingletPlacingCount: bingletPlacingCount)
            if let gridVectorToBeBlocked {
                gameBoardData.nodePlaceDataMatrix[gridVectorToBeBlocked.y][gridVectorToBeBlocked.x].blockState = .willBeBlocked(
                    bingletPlacingCountToBeBlocked: bingletPlacingCount + Constant.nodePlaceBlockStartCount
                )
            }
        }
        return gameBoardData
    }

    /// 반시계 방향 빙글빙글
    static func getGridVectorToBeBlocked(bingletPlacingCount: UInt) -> GridVector? {
        let quotient = bingletPlacingCount / Constant.nodePlaceBlockPeriod
        guard quotient < Constant.gameBoardVerticalNodeCount * Constant.gameBoardHorizontalNodeCount else {
            return nil
        }
        var consumableQuotient = quotient

        var bigSegmentIndex = 0
        for i in 0..<min(Constant.gameBoardVerticalNodeCount / 2, Constant.gameBoardHorizontalNodeCount / 2) {
            let bigSegmentSize
            = UInt(
                2 * (Constant.gameBoardHorizontalNodeCount - 2 * i - 1)
                + 2 * (Constant.gameBoardVerticalNodeCount - 2 * i - 1)
            )
            if bigSegmentSize <= consumableQuotient {
                consumableQuotient -= bigSegmentSize
            } else {
                bigSegmentIndex = i
                break
            }
        }

        var smallSegmentIndex = 0
        for i in 0..<4 {
            let smallSegmentSize: UInt
            switch i {
            case 0, 2:
                smallSegmentSize = UInt(Constant.gameBoardHorizontalNodeCount - 2 * bigSegmentIndex - 1)
            case 1, 3:
                smallSegmentSize = UInt(Constant.gameBoardVerticalNodeCount - 2 * bigSegmentIndex - 1)
            default:
                smallSegmentSize = UInt(Constant.gameBoardHorizontalNodeCount - 2 * bigSegmentIndex - 1)
            }
            if smallSegmentSize <= consumableQuotient {
                consumableQuotient -= smallSegmentSize
            } else {
                smallSegmentIndex = i
                break
            }
        }

        switch smallSegmentIndex {
        case 0:
            return GridVector(
                x: Constant.gameBoardHorizontalNodeCount - 1 - bigSegmentIndex - Int(consumableQuotient),
                y: bigSegmentIndex
            )
        case 1:
            return GridVector(
                x: bigSegmentIndex,
                y: bigSegmentIndex + Int(consumableQuotient)
            )
        case 2:
            return GridVector(
                x: bigSegmentIndex + Int(consumableQuotient),
                y: Constant.gameBoardVerticalNodeCount - 1 - bigSegmentIndex
            )
        case 3:
            return GridVector(
                x: Constant.gameBoardHorizontalNodeCount - 1 - bigSegmentIndex,
                y: Constant.gameBoardVerticalNodeCount - 1 - bigSegmentIndex - Int(consumableQuotient)
            )
        default:
            return GridVector(
                x: Constant.gameBoardHorizontalNodeCount - 1 - bigSegmentIndex - Int(consumableQuotient),
                y: bigSegmentIndex
            )
        }
    }

    // MARK: - Visual

    static func getVisualMultiplicationValue(comboCount: UInt) -> Int? {
        comboCount > 0 ? getMultiplicationValue(comboCount: comboCount) : nil
    }

    static func getNodeEffectMainColor(comboCount: UInt) -> Color {
        let red = 70 + (120 + Int(comboCount) * 77) % 125
        let green = 70 + (200 + Int(comboCount) * 56) % 125
        let blue = 70 + (176 + Int(comboCount) * 92) % 125
        return Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}
