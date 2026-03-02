// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

final actor AppStateAgentStorageWorker {

    // MARK: - Private Properties

    private let fileManager = FileManager.default

    private var appSupportDirectory: URL {
        get throws {
            try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        }
    }

    // MARK: - Interface

    func get<T: Decodable & Sendable>(_ type: T.Type, forKey key: AppStateAgentStorageKey) async -> T? {
        do {
            let fileURL = try fileURL(for: key)
            guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            await logDirector.agentLog(
                .appState,
                .error,
                "Failed to get value for storage key `\(key)`. error: \(error)"
            )
            return nil
        }
    }

    func set<T: Encodable & Sendable>(_ value: T?, forKey key: AppStateAgentStorageKey) async {
        do {
            let fileURL = try fileURL(for: key)
            guard let value = value else {
                try? fileManager.removeItem(at: fileURL)
                return
            }
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            await logDirector.agentLog(
                .appState,
                .error,
                "Failed to set value for storage key `\(key)`. error: \(error)"
            )
        }
    }

    // MARK: - Private Methods

    private func fileURL(for key: AppStateAgentStorageKey) throws -> URL {
        try appSupportDirectory.appendingPathComponent(key.rawValue)
    }
}
