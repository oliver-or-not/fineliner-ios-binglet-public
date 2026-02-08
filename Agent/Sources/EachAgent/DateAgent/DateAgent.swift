// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import AgentBase

// MARK: - Body

extension GlobalEntity.Agent {

    public static let dateAgent: DateAgentInterface = DateAgent(
        activationLevel: .inactive
    )
}

public protocol DateAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func getNowDate() async -> Date

    func getWeekNumberOfDate(_ date: Date) async -> Int

    func getYearOfWeekNumber(_ weekNumber: Int) async -> Int

    func getStartDateOfWeekNumber(_ weekNumber: Int) async -> Date

    func getEndDateOfWeekNumber(_ weekNumber: Int) async -> Date

    func getStartWeekNumberOfYear(_ year: Int) async -> Int

    func getEndWeekNumberOfYear(_ year: Int) async -> Int
}

fileprivate final actor DateAgent: DateAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .date

    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.firstWeekday = 2 // 월요일
        guard let gmtTimeZone = TimeZone(secondsFromGMT: 0) else {
            fatalError("Time zone is not set properly.")
        }
        calendar.timeZone = gmtTimeZone
        return calendar
    }()

    /// 2025년 1월 4일
    private var referenceDate: Date {
        let referenceComponents = DateComponents(calendar: calendar, year: 2025, month: 1, day: 4)
        guard let referenceDate = calendar.date(from: referenceComponents) else {
            fatalError("Reference date is not set properly.")
        }
        return referenceDate
    }

    /// 2025년 1월 4일이 포함된 주의 시작일
    private var startDateOfReferenceWeek: Date {
        guard let dateInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate) else {
            fatalError("Reference week interval is not set properly.")
        }
        return dateInterval.start
    }

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - DateAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func getNowDate() async -> Date {
        return Date()
    }

    func getWeekNumberOfDate(_ date: Date) async -> Int {
        // 현재 날짜의 시작 주
        guard let startDateOfCurrentWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else {
            fatalError()
        }

        let diff = calendar.dateComponents([.weekOfYear], from: startDateOfReferenceWeek, to: startDateOfCurrentWeek)
        guard let weekNumber = diff.weekOfYear else {
            fatalError()
        }
        return weekNumber
    }

    func getYearOfWeekNumber(_ weekNumber: Int) async -> Int {
        guard let targetDate = calendar.date(byAdding: .weekOfYear, value: weekNumber, to: startDateOfReferenceWeek) else {
            fatalError()
        }
        return calendar.component(.year, from: targetDate)
    }

    func getStartDateOfWeekNumber(_ weekNumber: Int) async -> Date {
        guard let startDate = calendar.date(byAdding: .weekOfYear, value: weekNumber, to: startDateOfReferenceWeek) else {
            fatalError()
        }
        return startDate
    }

    func getEndDateOfWeekNumber(_ weekNumber: Int) async -> Date {
        guard let startDate = calendar.date(byAdding: .weekOfYear, value: weekNumber, to: startDateOfReferenceWeek) else {
            fatalError()
        }
        guard let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else {
            fatalError()
        }
        return endDate
    }

    func getStartWeekNumberOfYear(_ year: Int) async -> Int {
        guard let jan4 = calendar.date(from: DateComponents(calendar: calendar, year: year, month: 1, day: 4)) else {
            fatalError()
        }
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: jan4) else {
            fatalError()
        }
        guard let weekNumber = calendar.dateComponents([.weekOfYear], from: startDateOfReferenceWeek, to: weekInterval.start).weekOfYear else {
            fatalError()
        }
        return weekNumber
    }

    func getEndWeekNumberOfYear(_ year: Int) async -> Int {
        guard let dec28 = calendar.date(from: DateComponents(calendar: calendar, year: year, month: 12, day: 28)) else {
            fatalError()
        }
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: dec28) else {
            fatalError()
        }
        guard let weekNumber = calendar.dateComponents([.weekOfYear], from: startDateOfReferenceWeek, to: weekInterval.start).weekOfYear else {
            fatalError()
        }
        return weekNumber
    }
}
