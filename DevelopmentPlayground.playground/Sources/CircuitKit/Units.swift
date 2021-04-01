import Foundation

extension UnitFrequency {
    static var radiansPerSecond = UnitFrequency(symbol: "rad/s", converter: UnitConverterLinear(coefficient: 2 * .pi))
}

// MARK: - Voltage and current

protocol Sinusoidal: CustomStringConvertible {
    var omega: Measurement<UnitFrequency> { get set }
    var value: Complex { get set }
    
    associatedtype AssociatedUnit: Dimension
    static var displayUnit: AssociatedUnit { get set }
}

extension Sinusoidal {
    var phase: Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value: value.argument, unit: .radians)
    }
    
    var peak: Measurement<AssociatedUnit> {
        return Measurement<AssociatedUnit>(value: value.modulus, unit: Self.displayUnit)
    }
    
    var rms: Measurement<AssociatedUnit> {
        return Measurement<AssociatedUnit>(value: value.modulus / 2.squareRoot(), unit: Self.displayUnit)
    }
}

// CustomStringConvertible conformance
extension Sinusoidal {
    public var description: String {
        return "\(peak) peak @ \(omega.converted(to: .hertz)) with \(phase.converted(to: .degrees)) phase"
    }
}

public struct Voltage: Sinusoidal {
    public var omega: Measurement<UnitFrequency>
    public var value: Complex
    
    static var displayUnit: UnitElectricPotentialDifference = .volts
    public typealias AssociatedUnit = UnitElectricPotentialDifference
    
    public init(peak: Measurement<AssociatedUnit>, phase: Measurement<UnitAngle>, omega: Measurement<UnitFrequency>) {
        self.omega = omega
        value = Complex(modulus: peak.converted(to: Self.displayUnit).value, argument: phase.converted(to: .radians).value)
    }
    
    public init(rms: Measurement<AssociatedUnit>, phase: Measurement<UnitAngle>, omega: Measurement<UnitFrequency>) {
        self.omega = omega
        value = Complex(modulus: rms.converted(to: Self.displayUnit).value * 2.squareRoot(), argument: phase.converted(to: .radians).value)
    }
}

struct Current: Sinusoidal {
    public var omega: Measurement<UnitFrequency>
    public var value: Complex
    
    static var displayUnit: UnitElectricCurrent = .amperes
    public typealias AssociatedUnit = UnitElectricCurrent
    
    public init(peak: Measurement<AssociatedUnit>, phase: Measurement<UnitAngle>, omega: Measurement<UnitFrequency>) {
        self.omega = omega
        value = Complex(modulus: peak.converted(to: Self.displayUnit).value, argument: phase.converted(to: .radians).value)
    }
    
    public init(rms: Measurement<AssociatedUnit>, phase: Measurement<UnitAngle>, omega: Measurement<UnitFrequency>) {
        self.omega = omega
        value = Complex(modulus: rms.converted(to: Self.displayUnit).value * 2.squareRoot(), argument: phase.converted(to: .radians).value)
    }
}

// MARK: -  Impedance and admittance

public protocol SupportsSeriesAndParallels {
    var value: Complex { get }
    static func fromSeries(of items: [SupportsSeriesAndParallels]) -> Self
    static func fromParallel(of items: [SupportsSeriesAndParallels]) -> Self
}

public struct Impedance: SupportsSeriesAndParallels, CustomStringConvertible {
    public init(value: Complex) {
        self.value = value
    }
    
    public var value: Complex
    
    public static func fromSeries(of items: [SupportsSeriesAndParallels]) -> Impedance {
        let totalImpedanceValue: Complex = items.map({ item -> Complex in
            if let admittance = item as? Admittance {
                return admittance.asImpedance().value
            } else if let impedance = item as? Impedance {
                return impedance.value
            } else {
                print("You have defined a new serial/parallel unit without implementing its conversion!")
                return .complexZero
            }
        })
        .reduce(.complexZero, { x, y in
            x + y
        })
        
        return Impedance(value: totalImpedanceValue)
    }
    
    public static func fromParallel(of items: [SupportsSeriesAndParallels]) -> Impedance {
        let totalImpedanceValueInverse: Complex = items.map({ item -> Complex in
            if let admittance = item as? Admittance {
                return admittance.asImpedance().value
            } else if let impedance = item as? Impedance {
                return impedance.value
            } else {
                print("You have defined a new serial/parallel unit without implementing its conversion!")
                return .complexZero
            }
        })
        .reduce(.complexZero, { x, y in
            if x == 0 {
                return y
            } else if y == 0 {
                return x
            } else {
                return (1 / x) + (1 / y)
            }
        })
        
        return Impedance(value: 1 / totalImpedanceValueInverse)
    }
    
    public func asAdmittance() -> Admittance {
        return Admittance(value: 1 / value)
    }
    
    // CustomStringConvertible conformance
    public var description: String {
        return "\(value.description)Ω"
    }
}

public struct Admittance: SupportsSeriesAndParallels, CustomStringConvertible {
    public init(value: Complex) {
        self.value = value
    }
    
    public var value: Complex
    
    public static func fromSeries(of items: [SupportsSeriesAndParallels]) -> Admittance {
        Impedance.fromSeries(of: items).asAdmittance()
    }
    
    public static func fromParallel(of items: [SupportsSeriesAndParallels]) -> Admittance {
        Impedance.fromParallel(of: items).asAdmittance()
    }
    
    public func asImpedance() -> Impedance {
        return Impedance(value: 1 / value)
    }
    
    // CustomStringConvertible conformance
    public var description: String {
        return "\(value.description)S"
    }
}