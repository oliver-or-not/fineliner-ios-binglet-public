// MARK: - Body

public struct BitMask256 {

    private var blocks: (UInt64, UInt64, UInt64, UInt64)

    public init(blocks: (UInt64, UInt64, UInt64, UInt64) = (0,0,0,0)) {
        self.blocks = blocks
    }

    @inline(__always)
    public mutating func insert(_ index: Int) {
        let block = index >> 6         // index / 64
        let offset = index & 63        // index % 64
        let bit: UInt64 = 1 << offset

        switch block {
        case 0: blocks.0 |= bit
        case 1: blocks.1 |= bit
        case 2: blocks.2 |= bit
        case 3: blocks.3 |= bit
        default: fatalError("Index out of 0~255 range")
        }
    }

    @inline(__always)
    public func contains(_ index: Int) -> Bool {
        let block = index >> 6
        let offset = index & 63
        let bit: UInt64 = 1 << offset

        switch block {
        case 0: return (blocks.0 & bit) != 0
        case 1: return (blocks.1 & bit) != 0
        case 2: return (blocks.2 & bit) != 0
        case 3: return (blocks.3 & bit) != 0
        default: return false
        }
    }

    @inline(__always)
    public func inserting(_ index: Int) -> BitMask256 {
        var new = self
        new.insert(index)
        return new
    }
}
