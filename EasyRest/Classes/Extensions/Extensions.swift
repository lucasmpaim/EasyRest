////
////  Extensions.swift
////  Pods
////
////  Created by Lucas Paim on 15/11/16.
////
////
//
//import Foundation
//
//
//extension Array : NodeConvertible {
//
//    public init(node: Node, in context: Context) throws {
//        self.init()
//        if !(Element.self is NodeInitializable.Type) {
//            fatalError("Make \(Element.self) a NodeConvertible!")
//        }
//        try node.nodeArray?.forEach {
//            let instance = try (Element.self as! NodeInitializable.Type).init(node: $0, in: context)
//            self.append(instance as! Element)
//        }
//    }
//
//    public func makeNode(context: Context) throws -> Node {
//        var array: [Node] = []
//        for item in self {
//            if let _item = item as? NodeConvertible {
//                try array.append(_item.makeNode())
//            } else {
//                fatalError("Make \(Element.self) a NodeConvertible!")
//            }
//        }
//        return Node.array(array)
//    }
//
//}


extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
