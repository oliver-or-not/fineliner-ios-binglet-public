// MARK: - Body

public extension Int {

    func power(_ exponent: UInt) -> Int {
        if exponent == 0 { return 1 }
        var result = 1
        for _ in 0..<exponent {
            result *= self
        }
        return result
    }
}
