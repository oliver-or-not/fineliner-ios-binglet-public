// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum
import AgentBase

// MARK: - Context

fileprivate typealias Constant = PlateStackAgentConstant
fileprivate typealias Logic = PlateStackAgentLogic
@MainActor fileprivate let windowModel = PlateStackWindowModel.shared

// MARK: - Body

extension GlobalEntity.Agent {

    public static let plateStackAgent: PlateStackAgentInterface = PlateStackAgent(
        activationLevel: .inactive,
        plateStack: []
    )
}

public protocol PlateStackAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    /// 플레이트를 플레이트 스택에 추가한다.
    func pushPlate(_: PlateDesignation, _: PlatePushStyle) async

    /// 최상위의 플레이트를 플레이트 스택에서 제거한다.
    func popPlate() async

    /// 현재의 플레이트 스택 정보를 얻는다.
    func getCurrentPlateStack() async -> [(PlateDesignation, PlatePushStyle)]
}

fileprivate final actor PlateStackAgent: PlateStackAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .plateStack

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel
    private var plateStack: [(PlateDesignation, PlatePushStyle)]

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel,
        plateStack: [(PlateDesignation, PlatePushStyle)]
    ) {
        self.activationLevel = activationLevel
        self.plateStack = plateStack
    }

    // MARK: - PlateStackAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func pushPlate(
        _ pushedPlateDesignation: PlateDesignation,
        _ platePushStyle: PlatePushStyle
    ) async {
        plateStack.append((pushedPlateDesignation, platePushStyle))
        let smallestVisiblePlateIndex: Int? = {
            guard plateStack.count > 0 else {
                return nil
            }
            for i in (0..<plateStack.count).reversed() {
                if plateStack[i].0.isOpaque() {
                    return i
                } else {
                    continue
                }
            }
            return 0
        }()
        let visiblePlateStack: [(PlateDesignation, PlatePushStyle)]
        if let smallestVisiblePlateIndex {
            visiblePlateStack = Array(plateStack[smallestVisiblePlateIndex...])
        } else {
            visiblePlateStack = []
        }
        switch platePushStyle {
        case .withoutAnimation:
            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        case .fadeIn:
            await MainActor.run {
                windowModel.unstablePlateDesignation = pushedPlateDesignation
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }

            let duration = Constant.platePushDurationForFadeIn
            let steps = max(1, Int(duration * Double(Constant.fps)))

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let smoothT = Logic.smooth(t: t)

                await MainActor.run {
                    windowModel.unstablePlateOpacity = smoothT
                }
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / Double(Constant.fps)))
            }

            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        case .fromTrailing:
            await MainActor.run {
                windowModel.unstablePlateDesignation = pushedPlateDesignation
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint(x: 1, y: 0)
                windowModel.unstablePlateCornerRadius = Constant.plateCornerRadius
                windowModel.unstablePlateOpacity = 1
            }

            let duration = Constant.platePushDurationForFromTrailing
            let steps = max(1, Int(duration * Double(Constant.fps)))

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let smoothT = Logic.smooth(t: t)

                await MainActor.run {
                    windowModel.unstablePlateRelativeOffset = CGPoint(x: 1 - smoothT, y: 0)
                    windowModel.unstablePlateCornerRadius = Constant.plateCornerRadius * (1 - smoothT)
                }
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / Double(Constant.fps)))
            }

            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        case .fromBottom:
            await MainActor.run {
                windowModel.unstablePlateDesignation = pushedPlateDesignation
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint(x: 0, y: 1)
                windowModel.unstablePlateCornerRadius = Constant.plateCornerRadius
                windowModel.unstablePlateOpacity = 1
            }

            let duration = Constant.platePushDurationForFromBottom
            let steps = max(1, Int(duration * Double(Constant.fps)))

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let smoothT = Logic.smooth(t: t)

                await MainActor.run {
                    windowModel.unstablePlateRelativeOffset = CGPoint(x: 0, y: 1 - smoothT)
                    windowModel.unstablePlateCornerRadius = Constant.plateCornerRadius * (1 - smoothT)
                }
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / Double(Constant.fps)))
            }

            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        }
    }

    func popPlate() async {
        guard let poppedTuple = plateStack.popLast() else {
            // 플레이트 스택이 비어 있으면 아무 동작도 하지 않는다.
            return
        }
        let smallestVisiblePlateIndex: Int? = {
            guard plateStack.count > 0 else {
                return nil
            }
            for i in (0..<plateStack.count).reversed() {
                if plateStack[i].0.isOpaque() {
                    return i
                } else {
                    continue
                }
            }
            return 0
        }()
        let visiblePlateStack: [(PlateDesignation, PlatePushStyle)]
        if let smallestVisiblePlateIndex {
            visiblePlateStack = Array(plateStack[smallestVisiblePlateIndex...])
        } else {
            visiblePlateStack = []
        }

        let poppedPlateDesignation = poppedTuple.0
        let platePopStyle = poppedTuple.1.correspondingPopStyle

        switch platePopStyle {
        case .withoutAnimation:
            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        case .fadeOut:
            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = poppedPlateDesignation
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 1
            }

            let duration = Constant.platePopDurationForFadeOut
            let steps = max(1, Int(duration * Double(Constant.fps)))

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let smoothT = Logic.smooth(t: t)

                await MainActor.run {
                    windowModel.unstablePlateOpacity = 1 - smoothT
                }
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / Double(Constant.fps)))
            }

            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        case .toTrailing:
            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = poppedPlateDesignation
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 1
            }

            let duration = Constant.platePopDurationForToTrailing
            let steps = max(1, Int(duration * Double(Constant.fps)))

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let smoothT = Logic.smooth(t: t)

                await MainActor.run {
                    windowModel.unstablePlateRelativeOffset = CGPoint(x: smoothT, y: 0)
                    windowModel.unstablePlateCornerRadius = Constant.plateCornerRadius * smoothT
                }
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / Double(Constant.fps)))
            }

            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint(x: 1, y: 0)
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        case .toBottom:
            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = poppedPlateDesignation
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint()
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 1
            }

            let duration = Constant.platePopDurationForToBottom
            let steps = max(1, Int(duration * Double(Constant.fps)))

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let smoothT = Logic.smooth(t: t)

                await MainActor.run {
                    windowModel.unstablePlateRelativeOffset = CGPoint(x: 0, y: smoothT)
                    windowModel.unstablePlateCornerRadius = Constant.plateCornerRadius * smoothT
                }
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / Double(Constant.fps)))
            }

            await MainActor.run {
                windowModel.stablePlateDesignationArray = visiblePlateStack.map(\.0)
                windowModel.stablePlateDistance = 0
                windowModel.stablePlateRelativeOffset = CGPoint()
                windowModel.stablePlateCornerRadius = 0
                windowModel.stablePlateOpacity = 1

                windowModel.unstablePlateDesignation = nil
                windowModel.unstablePlateDistance = 0
                windowModel.unstablePlateRelativeOffset = CGPoint(x: 0, y: 1)
                windowModel.unstablePlateCornerRadius = 0
                windowModel.unstablePlateOpacity = 0
            }
        }
    }

    func getCurrentPlateStack() async -> [(PlateDesignation, PlatePushStyle)] {
        plateStack
    }
}
