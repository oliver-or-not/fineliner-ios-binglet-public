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

    func get<T: Decodable & Sendable>(_ type: T.Type, forKey key: AppStateAgentStorageKey) async -> T? {
        let defaults = UserDefaults.standard

        switch type {
        case is URL.Type:
            return defaults.url(forKey: key.rawValue) as? T
        case is Int.Type, is Float.Type, is Double.Type, is Bool.Type,
            is String.Type, is Date.Type, is Data.Type,
            is [Int].Type, is [Float].Type, is [Double].Type, is [Bool].Type,
            is [String].Type, is [Date].Type, is [Data].Type, is [URL].Type,
            is [String: Int].Type, is [String: Float].Type, is [String: Double].Type, is [String: Bool].Type,
            is [String: String].Type, is [String: Date].Type, is [String: Data].Type, is [String: URL].Type:
            return defaults.object(forKey: key.rawValue) as? T
        default:
            guard let data = defaults.data(forKey: key.rawValue) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
    }

    func set<T: Encodable & Sendable>(_ value: T?, forKey key: AppStateAgentStorageKey) async {
        let defaults = UserDefaults.standard

        guard let value = value else {
            defaults.removeObject(forKey: key.rawValue)
            return
        }

        if let url = value as? URL {
            defaults.set(url, forKey: key.rawValue)
        } else {
            switch value {
            case is Int, is Float, is Double, is Bool, is String, is Date, is Data,
                is [Int], is [Float], is [Double], is [Bool], is [String], is [Date], is [Data], is [URL],
                is [String: Int], is [String: Float], is [String: Double], is [String: Bool],
                is [String: String], is [String: Date], is [String: Data], is [String: URL]:
                defaults.set(value, forKey: key.rawValue)
            default:
                do {
                    let encoded = try JSONEncoder().encode(value)
                    defaults.set(encoded, forKey: key.rawValue)
                } catch {
                    await logDirector.agentLog(
                        .appState,
                        .error,
                        "Failed to encode value for storage key `\(key)`. error: \(error)"
                    )
                }
            }
        }
    }
}
