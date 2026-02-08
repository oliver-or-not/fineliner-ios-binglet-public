// MARK: - Module Dependency

import Spectrum
import Director
import Agent
import PrimeEvent

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

@MainActor final class PrimeEventSubscriber {

    private var task: Task<Void, Never>?

    func start() {
        task = Task {
            let stream = await primeEventDirector.makeStream()
            for await (designationWithPayload, correlationId) in stream {
                Task { @MainActor in
                    await designationWithPayload.designation.interface.task(designationWithPayload)
                    await primeEventDirector.markCompleted(correlationId: correlationId)
                }
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }
}
