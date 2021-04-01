//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport
import Foundation

let a = Node("A")
let b = Node("B")

let c1 = Capacitor(capacitance: Measurement<UnitCapacitance>(value: 100, unit: .microFarad), between: a, and: b)
c1.nodeA
c1.nodeB

let v0 = Voltage(rms: Measurement<UnitElectricPotentialDifference>(value: 230, unit: .volts),
                 phase: Measurement<UnitAngle>(value: 90, unit: .degrees),
                 omega: Measurement<UnitFrequency>(value: 50, unit: .hertz))

let i0 = v0/c1.impedance(v0.omega)
