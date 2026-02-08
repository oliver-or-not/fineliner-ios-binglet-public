// MARK: - Body

/// 큐.
///
/// Data racing 에 대한 방어를 자체적으로 하지 않는다.
public struct Queue<T> {

    // MARK: - Reference

    // MARK: - Constant

    // MARK: - State

    private var head: Node<T>?
    private var tail: Node<T>?
    private var _count: Int = 0

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Interface

    /// Queue가 비었는지 확인.
    public var isEmpty: Bool {
        return head == nil
    }

    /// Queue가 비지 않았는지 확인.
    public var isNotEmpty: Bool {
        return head != nil
    }

    /// 첫 번째 요소를 확인. (삭제 안 함.)
    public func peek() -> T? {
        return head?.value
    }

    /// 큐에 속한 노드의 수.
    public var count: Int {
        return _count
    }

    /// 요소 추가. (O(1))
    public mutating func enqueue(_ element: T) {
        let newNode = Node(element)
        if let tailNode = tail {
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
        _count += 1
    }

    /// 요소 제거. (O(1))
    @discardableResult
    public mutating func dequeue() -> T? {
        guard let headNode = head else { return nil }
        head = headNode.next
        if head == nil { // 큐가 비면 tail도 nil로 초기화.
            tail = nil
        }
        _count -= 1
        return headNode.value
    }
}

// for-in 지원
extension Queue: Sequence {

    public struct Iterator: IteratorProtocol {

        private var current: Node<T>?

        fileprivate init(_ start: Node<T>?) { self.current = start }

        public mutating func next() -> T? {
            let v = current?.value
            current = current?.next
            return v
        }
    }
    public func makeIterator() -> Iterator { Iterator(head) }
}
