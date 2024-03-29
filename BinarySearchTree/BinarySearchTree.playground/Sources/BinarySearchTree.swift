import Foundation

public enum BinarySearchTree<T: Comparable> {
    case empty
    case leaf(T)
    /// indirect used for recursive enum case
    /// - Provides layer of indirection for case referencing
    /// - Allows for enum size to grow without infinite memory risk
    indirect case node(BinarySearchTree, T, BinarySearchTree)
    
    public var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .leaf(_):
            return 1
        case .empty:
            return 0
        }
    }
    
    private func treeWithInsertedValue(newValue: T) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, newValue, .empty)
        case let .leaf(value):
            if newValue < value {
                return .node(.leaf(newValue), value, .empty)
            } else {
                return .node(.empty, value, .leaf(newValue))
            }
        case let .node(left, value, right):
            if (newValue < value) {
                return .node(left.treeWithInsertedValue(newValue: newValue), value, right)
            } else {
                return .node(left, value, right.treeWithInsertedValue(newValue: newValue))
            }
        }
    }
    
    public mutating func insert(newValue: T) {
        self = treeWithInsertedValue(newValue: newValue)
    }
    
    /// Searches for the "highest" node with the specified value: x
    /// Time Complexity: O(log n) such that n = numebr of nodes in the tree
    public func search(forValue: T) -> BinarySearchTree? {
        switch self {
        case .empty:
            return nil
        case let .leaf(value):
            return (forValue == value) ? self : nil
        case let .node(left, value, right):
            if (forValue == value) {
                return self
            } else if (forValue < value) {
                return left.search(forValue: forValue)
            } else {
                return right.search(forValue: forValue)
            }
        }
    }
    
    /// Traverses Binary Tree in order
    /// Time Complexity: O(n) such that n = number of nodes in tree
    public func traverseInOrder(processValue: (T) -> ()) {
        switch self {
        case .empty:
            return
        case let .leaf(value):
            processValue(value)
        case let .node(left, value, right):
            left.traverseInOrder(processValue: processValue)
            processValue(value)
            right.traverseInOrder(processValue: processValue)
        }
    }

    /// Traverses Binary Tree pre order
    /// Time Complexity: O(n) such that n = number of nodes in tree
    public func traversePreOrder(processValue: (T) -> ()) {
        switch self {
        case .empty:
            return
        case let .leaf(value):
            processValue(value)
        case let .node(left, value, right):
            processValue(value)
            left.traversePreOrder(processValue: processValue)
            right.traversePreOrder(processValue: processValue)
        }
    }

    /// Traverses Binary Tree post order
    /// Time Complexity: O(n) such that n = number of nodes in tree
    public func traversePostOrder(processValue: (T) -> ()) {
        switch self {
        case .empty:
            return
        case let .leaf(value):
            processValue(value)
        case let .node(left, value, right):
            left.traversePostOrder(processValue: processValue)
            right.traversePostOrder(processValue: processValue)
            processValue(value)
        }
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
    switch self {
    case let .node(left, value, right):
//        return "value: \(value), left = [" + left.description + "], right = [" + right.description + "]"
        return "(\(left.description)) <- \(value) -> (\(right.description))"
    case let .leaf(value):
        return "\(value)"
    case .empty:
        return "."
    }
  }
}
