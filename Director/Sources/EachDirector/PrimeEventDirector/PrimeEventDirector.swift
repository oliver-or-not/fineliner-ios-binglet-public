// MARK: - Module Dependency

import os
import SwiftUI
import Universe
import Spectrum
import DirectorBase

// MARK: - Context

fileprivate typealias Constant = PrimeEventDirectorConstant
@MainActor fileprivate let windowModel = PrimeEventWindowModel.shared

// MARK: - Body

extension GlobalEntity.Director {

    @MainActor public static let primeEvent: PrimeEventDirectorInterface = PrimeEventDirector(
        // 앱이 시작될 때 이미 활성화되어 있어야 하므로 초기 상태를 active로 한다.
        activationLevel: .active
    )
}

public protocol PrimeEventDirectorInterface: GlobalEntity.Director.Interface, Sendable {

    /// Prime event를 발행하는 스트림을 생성한다.
    func makeStream() async -> AsyncStream<(PrimeEventDesignationWithPayload, String)>

    /// Prime event의 발생을 전달받는다.
    func receive(_ designation: PrimeEventDesignationWithPayload) async

    /// Correlation id에 대응되는 prime event의 작업이 끝났음을 전달받는다.
    func markCompleted(correlationId: String) async

    func timeElapsed(now: Date) async

    func getIsWindowVisible() async -> Bool

    func setIsWindowVisible(_ isVisible: Bool) async
}

@MainActor fileprivate final class PrimeEventDirector: PrimeEventDirectorInterface {
    // PrimeEventDirector는 UI 작업과 동등한 처리 우선순위가 필요하므로 MainActor class로 정의한다.

    // MARK: - Reference

    private let logger: Logger
    /// 스트림 바깥에서 이벤트를 주입할 수 있게 보관해 두는 continuation.
    ///
    /// self.continuation.yield(...) 호출로 이벤트를 전달할 수 있다.
    private var continuation: AsyncStream<(PrimeEventDesignationWithPayload, String)>.Continuation?

    // MARK: - Constant

    nonisolated let designation: DirectorDesignation = .primeEvent

    // MARK: - State

    var activationLevel: GlobalEntity.Director.ActivationLevel
    /// 처리되어야 하는 prime event의 배열.
    ///
    /// 인덱스가 클수록 나중에 추가된 prime event이다.
    private var waitingArray: Array<PrimeEventDesignationWithPayload> = .init() {
        didSet {
            windowModel.waitingArray = Array(
                waitingArray.map(\.designation)
                // .timeElapsed 는 너무 빈번하므로 제외한다.
                    .filter { .timeElapsed != $0 }
                    .prefix(Constant.windowModelWaitingArrayMaxCount)
            )
        }
    }
    /// 실행 중인 prime event의 배열.
    ///
    /// 인덱스가 클수록 나중에 추가된 prime event이다.
    private var performingArray: Array<(
        primeEventDesignationWithPayload: PrimeEventDesignationWithPayload,
        correlationId: String
    )> = .init() {
        didSet {
            windowModel.performingArray = Array(
                performingArray.map(\.primeEventDesignationWithPayload.designation)
                // .timeElapsed 는 너무 빈번하므로 제외한다.
                    .filter { .timeElapsed != $0 }
                    .prefix(Constant.windowModelPerformingArrayMaxCount)
            )
        }
    }

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Director.ActivationLevel
    ) {
        self.activationLevel = activationLevel

        let infoDictionary = Bundle.main.infoDictionary!
        let bundleIdString = infoDictionary["CFBundleIdentifier"] as? String
        let safeBundleIdString = bundleIdString ?? "bundle-id-is-missing"

        self.logger = Logger(
            subsystem: safeBundleIdString,
            category: "Director" + "/" + "primeEvent"
        )
    }

    // MARK: - PrimeEventDirectorInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Director.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func makeStream() async -> AsyncStream<(PrimeEventDesignationWithPayload, String)> {
        if continuation != nil {
            logger.log(level: .error, "makeStream has been called multiple times.")
        }
        return AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    func receive(_ primeEventDesignationWithPayload: PrimeEventDesignationWithPayload) async {
        // performingArray가 비어있으면 isPerformCompatible은 true.
        let isPerformCompatible = performingArray.allSatisfy { element in
            if element.primeEventDesignationWithPayload.designation
                .isExceptionallyPerformCompatibleWith(primeEventDesignationWithPayload.designation) {
                return true
            } else {
                switch primeEventDesignationWithPayload.designation.category {
                case .natural:
                    return true
                default:
                    switch element.primeEventDesignationWithPayload.designation.category {
                    case .natural:
                        return true
                    default:
                        return false
                    }
                }
            }
        }

        if isPerformCompatible && waitingArray.isEmpty {
            let correlationId = UUID().uuidString
            performingArray.append((primeEventDesignationWithPayload, correlationId))
            self.continuation?.yield((primeEventDesignationWithPayload, correlationId))
            return
        }

        // performingArray와 waitingArray가 비어있으면 isWaitCompatible은 true.
        let isWaitCompatible = (performingArray.map { $0.primeEventDesignationWithPayload } + waitingArray.map { $0 }).allSatisfy { primeEventDesignationWithPayloadInElement in
            let isWaitCompatible: Bool
            if primeEventDesignationWithPayloadInElement.designation.isExceptionallyWaitCompatibleWith(primeEventDesignationWithPayload.designation) {
                isWaitCompatible = true
            } else {
                switch primeEventDesignationWithPayload.designation.category {
                case .natural, .friendly:
                    isWaitCompatible = true
                case .hierarchical(let receivedScale):
                    switch primeEventDesignationWithPayloadInElement.designation.category {
                    case .natural, .friendly:
                        isWaitCompatible = true
                    case .hierarchical(let elementScale):
                        if elementScale.rawValue < receivedScale.rawValue {
                            isWaitCompatible = true
                        } else {
                            isWaitCompatible = false
                        }
                    }
                }
            }
            return isWaitCompatible
        }

        if isWaitCompatible {
            waitingArray.append(primeEventDesignationWithPayload)
        } else {
            // .timeElapsed 는 너무 빈번하므로 제외한다.
            if .timeElapsed != primeEventDesignationWithPayload.designation {
                windowModel.thrownArray.append((primeEventDesignationWithPayload.designation, Date.now))
                windowModel.thrownArray
                = windowModel.thrownArray.suffix(Constant.windowModelThrownArrayMaxCount)
            }
        }
    }

    func markCompleted(correlationId: String) async {
        for i in (0..<performingArray.count).reversed() {
            if self.performingArray[i].correlationId == correlationId {
                let completedPrimeEvent = self.performingArray.remove(at: i).primeEventDesignationWithPayload
                // .timeElapsed 는 너무 빈번하므로 제외한다.
                if .timeElapsed != completedPrimeEvent.designation {
                    windowModel.completedArray.append((completedPrimeEvent.designation, Date.now))
                    windowModel.completedArray
                    = windowModel.completedArray.suffix(Constant.windowModelCompletedArrayMaxCount)
                }
            }
        }
        while true {
            let primeEventDesignationWithPayload = self.waitingArray.first
            guard let primeEventDesignationWithPayload else { break }
            let isPerformCompatible = performingArray.allSatisfy { element in
                if element.primeEventDesignationWithPayload.designation
                    .isExceptionallyPerformCompatibleWith(primeEventDesignationWithPayload.designation) {
                    return true
                } else {
                    switch primeEventDesignationWithPayload.designation.category {
                    case .natural:
                        return true
                    default:
                        switch element.primeEventDesignationWithPayload.designation.category {
                        case .natural:
                            return true
                        default:
                            return false
                        }
                    }
                }
            }

            if isPerformCompatible {
                let correlationId = UUID().uuidString
                _ = self.waitingArray.remove(at: 0)
                performingArray.append((primeEventDesignationWithPayload, correlationId))
                self.continuation?.yield((primeEventDesignationWithPayload, correlationId))
                return
            } else {
                break
            }
        }
    }

    func timeElapsed(now: Date) async {
        for i in (0..<windowModel.thrownArray.count).reversed() {
            let tuple = windowModel.thrownArray[i]
            if tuple.1.addingTimeInterval(Constant.windowModelThrownRemovingTimeInterval) < now {
                windowModel.thrownArray.remove(at: i)
            }
        }

        for i in (0..<windowModel.completedArray.count).reversed() {
            let tuple = windowModel.completedArray[i]
            if tuple.1.addingTimeInterval(Constant.windowModelCompletedRemovingTimeInterval) < now {
                windowModel.completedArray.remove(at: i)
            }
        }
    }

    func getIsWindowVisible() async -> Bool {
        windowModel.isVisible
    }

    func setIsWindowVisible(_ isVisible: Bool) async {
        windowModel.isVisible = isVisible
    }
}
