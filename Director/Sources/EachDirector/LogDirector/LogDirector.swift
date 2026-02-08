// MARK: - Module Dependency

import os
import SwiftUI
import Universe
import Spectrum
import DirectorBase

// MARK: - Context

fileprivate typealias Constant = LogDirectorConstant
@MainActor fileprivate let windowModel = LogWindowModel.shared

// MARK: - Body

extension GlobalEntity.Director {

    public static let log: LogDirectorInterface = LogDirector(
        // 앱이 시작될 때 이미 활성화되어 있어야 하므로 초기 상태를 active로 한다.
        activationLevel: .active
    )
}

public protocol LogDirectorInterface: GlobalEntity.Director.Interface, Sendable {

    /// Agent 내부 동작의 로그를 남긴다.
    func agentLog(_ designation: AgentDesignation, _ logType: LogDirectorLogType, _ message: String) async

    /// Plate 내부 동작의 로그를 남긴다.
    func plateLog(_ designation: PlateDesignation, _ logType: LogDirectorLogType, _ message: String) async

    /// PrimeEvent에 대응되는 task 수행 중의 로그를 남긴다.
    func primeEventLog(_ designation: PrimeEventDesignation, _ logType: LogDirectorLogType, _ message: String) async

    func getIsWindowVisible() async -> Bool

    func setIsWindowVisible(_ isVisible: Bool) async
}

fileprivate final actor LogDirector: LogDirectorInterface {

    // MARK: - Reference

    private let logger: Logger
    private let agentLoggerMap: [AgentDesignation: Logger]
    private let plateLoggerMap: [PlateDesignation: Logger]
    private let primeEventLoggerMap: [PrimeEventDesignation: Logger]

    // MARK: - Constant

    nonisolated let designation: DirectorDesignation = .log

    // MARK: - State

    var activationLevel: GlobalEntity.Director.ActivationLevel

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
            category: "Director" + "/" + "log"
        )

        var agentLoggerMap: [AgentDesignation: Logger] = [:]
        AgentDesignation.allCases.forEach { agentDesignation in
            agentLoggerMap[agentDesignation] = Logger(
                subsystem: safeBundleIdString,
                category: "Agent" + "/" + agentDesignation.rawValue
            )
        }
        self.agentLoggerMap = agentLoggerMap

        var plateLoggerMap: [PlateDesignation: Logger] = [:]
        PlateDesignation.allCases.forEach { plateDesignation in
            plateLoggerMap[plateDesignation] = Logger(
                subsystem: safeBundleIdString,
                category: "Plate" + "/" + plateDesignation.rawValue
            )
        }
        self.plateLoggerMap = plateLoggerMap

        var primeEventLoggerMap: [PrimeEventDesignation: Logger] = [:]
        PrimeEventDesignation.allCases.forEach { primeEventDesignation in
            primeEventLoggerMap[primeEventDesignation] = Logger(
                subsystem: safeBundleIdString,
                category: "PrimeEvent" + "/" + primeEventDesignation.rawValue
            )
        }
        self.primeEventLoggerMap = primeEventLoggerMap
    }

    // MARK: - LogDirectorInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Director.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func agentLog(_ designation: AgentDesignation, _ logType: LogDirectorLogType, _ message: String) async {
        if let logger = self.agentLoggerMap[designation] {
            switch logType {
            case .debug:
                logger.log(level: .debug, "\(message)")
            case .info:
                logger.log(level: .info, "\(message)")
            case .default:
                logger.log(level: .default, "\(message)")
            case .error:
                logger.log(level: .error, "\(message)")
            case .fault:
                logger.log(level: .fault, "\(message)")
            }
        } else {
            logger.log(level: .error, "No logger for Agent/\(designation.rawValue); Message: \(message)")
        }
        await MainActor.run {
            windowModel.logFormArray.append(
                LogWindowModel.LogForm(
                    category: "Agent" + "/" + designation.rawValue,
                    logType: logType,
                    message: message
                )
            )
            windowModel.logFormArray = windowModel.logFormArray.suffix(Constant.windowModelLogFormArrayMaxCount)
        }
    }

    func plateLog(_ designation: PlateDesignation, _ logType: LogDirectorLogType, _ message: String) async {
        if let logger = self.plateLoggerMap[designation] {
            switch logType {
            case .debug:
                logger.log(level: .debug, "\(message)")
            case .info:
                logger.log(level: .info, "\(message)")
            case .default:
                logger.log(level: .default, "\(message)")
            case .error:
                logger.log(level: .error, "\(message)")
            case .fault:
                logger.log(level: .fault, "\(message)")
            }
        } else {
            logger.log(level: .error, "No logger for Plate/\(designation.rawValue); Message: \(message)")
        }
        await MainActor.run {
            windowModel.logFormArray.append(
                LogWindowModel.LogForm(
                    category: "Plate" + "/" + designation.rawValue,
                    logType: logType,
                    message: message
                )
            )
            windowModel.logFormArray = windowModel.logFormArray.suffix(Constant.windowModelLogFormArrayMaxCount)
        }
    }

    func primeEventLog(_ designation: PrimeEventDesignation, _ logType: LogDirectorLogType, _ message: String) async {
        if let logger = self.primeEventLoggerMap[designation] {
            switch logType {
            case .debug:
                logger.log(level: .debug, "\(message)")
            case .info:
                logger.log(level: .info, "\(message)")
            case .default:
                logger.log(level: .default, "\(message)")
            case .error:
                logger.log(level: .error, "\(message)")
            case .fault:
                logger.log(level: .fault, "\(message)")
            }
        } else {
            logger.log(level: .error, "No logger for PrimeEvent/\(designation.rawValue); Message: \(message)")
        }
        await MainActor.run {
            windowModel.logFormArray.append(
                LogWindowModel.LogForm(
                    category: "PrimeEvent" + "/" + designation.rawValue,
                    logType: logType,
                    message: message
                )
            )
            windowModel.logFormArray = windowModel.logFormArray.suffix(Constant.windowModelLogFormArrayMaxCount)
        }
    }

    func getIsWindowVisible() async -> Bool {
        await windowModel.isVisible
    }

    func setIsWindowVisible(_ isVisible: Bool) async {
        await MainActor.run {
            windowModel.isVisible = isVisible
        }
    }
}
