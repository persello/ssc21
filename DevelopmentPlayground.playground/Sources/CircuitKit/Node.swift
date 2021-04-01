import Foundation

public struct Node: Identifiable, Equatable {
    public var name: String
    public var voltage: Measurement<UnitElectricPotentialDifference>?
    public let id = UUID()
    
    public static func == (_ lhs: Node, _ rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var ground = Node(name: "GND", voltage: Measurement(value: 0, unit: .volts))
}
