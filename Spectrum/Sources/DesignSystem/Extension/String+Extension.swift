// MARK: - Body

public extension String {
    
    func superscript() -> String {
        let map: [Character: Character] = [
            "0":"⁰","1":"¹","2":"²","3":"³","4":"⁴",
            "5":"⁵","6":"⁶","7":"⁷","8":"⁸","9":"⁹"
        ]
        return self.map { map[$0] ?? $0 }.map(String.init).joined()
    }
}
