// MARK: - Body

actor AppStateAgentStorableItem<StorageDataType: Codable & Sendable, RamDataType: Sendable> {

    private var state: State = .notRestored
    private let storageKey: AppStateAgentStorageKey
    private let storageToRamTypeCastingClosure: (StorageDataType?) -> RamDataType
    private let ramToStorageTypeCastingClosure: (RamDataType) -> StorageDataType?
    private let storageWorker: AppStateAgentStorageWorker

    init(
        storageKey: AppStateAgentStorageKey,
        storageToRamTypeCastingClosure: @escaping (StorageDataType?) -> RamDataType,
        ramToStorageTypeCastingClosure: @escaping (RamDataType) -> StorageDataType?,
        storageWorker: AppStateAgentStorageWorker
    ) {
        self.storageKey = storageKey
        self.storageToRamTypeCastingClosure = storageToRamTypeCastingClosure
        self.ramToStorageTypeCastingClosure = ramToStorageTypeCastingClosure
        self.storageWorker = storageWorker
    }

    func get() async -> RamDataType {
        switch state {
        case .notRestored:
            let valueFromStorage = await storageWorker.get(StorageDataType.self, forKey: storageKey)
            let ramTypeValue = storageToRamTypeCastingClosure(valueFromStorage)
            state = .restored(ramTypeValue)
            return ramTypeValue
        case .restored(let value):
            return value
        }
    }

    func set(_ newValue: RamDataType) async {
        state = .restored(newValue)
        let storageTypeValue = ramToStorageTypeCastingClosure(newValue)
        await storageWorker.set(storageTypeValue, forKey: storageKey)
    }

    enum State {

        /// 영구 저장소로부터 값이 복원되지 않은 상태.
        case notRestored
        /// 영구 저장소로부터 값이 복원된 상태.
        case restored(RamDataType)
    }
}
