import Foundation

public class Node: Identifiable {
    internal init(name: String? = nil) {
        self.id = UUID()
        self.name = name
        self.connections = []
    }
    
    public var name: String?
    public var voltage: Measurement<UnitElectricPotentialDifference>?
    public var connections: [(Bipole, Bipole.Pin)]
    public var id: UUID

    static var ground: Node {
        let node = Node(name: "GND")
        node.voltage = Measurement(value: 0, unit: .volts)
        return node
    }
}

extension Node: Equatable {
    public static func == (_ lhs: Node, _ rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Node: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
