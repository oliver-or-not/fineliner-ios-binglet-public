// MARK: - Body

public final class Node<T> {

    public var value: T
    public var next: Node<T>?

    public init(_ value: T) {
        self.value = value
    }
}
