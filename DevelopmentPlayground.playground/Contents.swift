//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport

let a = Impedance(value: Complex(real: 100, imaginary: 0))
let b = Admittance(value: Complex(real: 10, imaginary: 0))

Impedance.fromSeries(of: [a, b])
Admittance.fromSeries(of: [a, b])

Impedance.fromParallel(of: [a, b])
Admittance.fromParallel(of: [a, b])


let c = Impedance(value: Complex(real: 0, imaginary: 10))
let d = Impedance(value: Complex(real: 0, imaginary: -10))

Impedance.fromSeries(of: [c, d])
Admittance.fromSeries(of: [c, d])
