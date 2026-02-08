// MARK: - Body

extension String {

    init(lKey: LocalizableKey) {
        self.init(localized: lKey.rawValue, table: "Localizable", bundle: .main)
    }
}
