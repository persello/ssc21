import Foundation

// MARK: - Protocol

protocol LinearComponent {
    var impedance: (Measurement<UnitFrequency>) -> Impedance { get }
}

// MARK: - Passive components

public final class Resistor: Bipole, LinearComponent {
    public init(resistance: Measurement<UnitElectricResistance>) {
        self.resistance = resistance

        impedance = { _ in
            Impedance(value: Complex(real: resistance.converted(to: .ohms).value, imaginary: 0))
        }
    }

    public var resistance: Measurement<UnitElectricResistance>
    public var impedance: (Measurement<UnitFrequency>) -> Impedance
}

public final class Capacitor: Bipole, LinearComponent {
    public init(capacitance: Measurement<UnitCapacitance>) {
        self.capacitance = capacitance

        impedance = { omega in
            let value = 1 / (1.0.j * omega.converted(to: .radiansPerSecond).value * capacitance.converted(to: .farad).value)
            return Impedance(value: value)
        }
    }

    public var capacitance: Measurement<UnitCapacitance>
    public var impedance: (Measurement<UnitFrequency>) -> Impedance
}

public final class Inductor: Bipole, LinearComponent {
    public init(inductance: Measurement<UnitInductance>) {
        self.inductance = inductance

        impedance = { omega in
            let value = (1.0.j * omega.converted(to: .radiansPerSecond).value * inductance.converted(to: .henry).value)
            return Impedance(value: value)
        }
    }

    public var inductance: Measurement<UnitInductance>
    public var impedance: (Measurement<UnitFrequency>) -> Impedance
}
