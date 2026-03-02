// MARK: - Body

extension String {
    
    init(lKey: LocalizableKey) {
        self.init(localized: lKey.localizationValue, table: "Localizable", bundle: .main)
    }
}
