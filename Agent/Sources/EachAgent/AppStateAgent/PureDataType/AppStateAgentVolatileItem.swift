// MARK: - Body

actor AppStateAgentVolatileItem<T: Codable & Sendable> {

    private var value: T

    init(value: T) {
        self.value = value
    }

    func get() async -> T {
        value
    }

    func set(_ newValue: T) async {
        value = newValue
    }
}
