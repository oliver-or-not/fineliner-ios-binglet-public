// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

public struct ActiveBingletProcessData: Codable, Hashable, Sendable {

    public var binglet: Binglet
    public var accumulatedPlacingChoice: AccumulatedPlacingChoice
    public var isHintVisible: Bool
    public var dragProcessData: DragProcessData?

    public var duplicatableGameBoardDataWithPlacedBingletCacheMap: [PlacingChoice: DuplicatableGameBoardData]
    public var gameBoardHintDataCacheMap: [PlacingChoice: GameBoardHintData]
    public var resolvedGameBoardDataCacheMap: [PlacingChoice: GameBoardData]

    public init(
        binglet: Binglet,
        accumulatedPlacingChoice: AccumulatedPlacingChoice,
        isHintVisible: Bool,
        dragProcessData: DragProcessData? = nil,
        duplicatableGameBoardDataWithPlacedBingletCacheMap: [PlacingChoice : DuplicatableGameBoardData],
        gameBoardHintDataCacheMap: [PlacingChoice : GameBoardHintData],
        resolvedGameBoardDataCacheMap: [PlacingChoice : GameBoardData]
    ) {
        self.binglet = binglet
        self.accumulatedPlacingChoice = accumulatedPlacingChoice
        self.isHintVisible = isHintVisible
        self.dragProcessData = dragProcessData
        self.duplicatableGameBoardDataWithPlacedBingletCacheMap = duplicatableGameBoardDataWithPlacedBingletCacheMap
        self.gameBoardHintDataCacheMap = gameBoardHintDataCacheMap
        self.resolvedGameBoardDataCacheMap = resolvedGameBoardDataCacheMap
    }

    public struct AccumulatedPlacingChoice: Codable, Hashable, Sendable {

        public var tapCount: UInt
        public var gridOffset: GridVector

        public init(
            tapCount: UInt,
            gridOffset: GridVector
        ) {
            self.tapCount = tapCount
            self.gridOffset = gridOffset
        }
    }

    public struct PlacingChoice: Codable, Hashable, Sendable {

        public var rotation: QuarterRotation
        public var gridOffset: GridVector

        public init(
            rotation: QuarterRotation,
            gridOffset: GridVector
        ) {
            self.rotation = rotation
            self.gridOffset = gridOffset
        }
    }

    public struct DragProcessData: Codable, Hashable, Sendable {

        public var gridOffsetWhenDragBegan: GridVector
        public var residualTranslation: CGSize

        public init(
            gridOffsetWhenDragBegan: GridVector,
            residualTranslation: CGSize
        ) {
            self.gridOffsetWhenDragBegan = gridOffsetWhenDragBegan
            self.residualTranslation = residualTranslation
        }
    }
}
