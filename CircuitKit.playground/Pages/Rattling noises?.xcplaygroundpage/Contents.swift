//: [Previous](Shhhhh!)
/*:
 ## Rattling noises?
 ---
 You have a quite old car, and its speakers are not as good as the ones you used for the first test. The woofers tend to rattle.

 Let's build a circuit that equalizes the sound by silencing the lowest frequencies. You have a spare 5Ω resistor from the previous circuit, and a 470μF capacitor. An RC high-pass filter will probably do:

 ![High-pass RC filter](highpass.png)

 Let's see if it can remove some of these annoying noises around 20~30 Hz.
 */
import Foundation

// Let's start with the same three nodes
let inputNode = Node("IN")
let outputNode = Node("OUT")
let ground = Node.ground

// Let's add the two components
let c1 = Capacitor(capacitance: 470e-6.farads, between: inputNode, and: outputNode)
let r2 = Resistor(resistance: 5.ohms, between: outputNode, and: ground)

// For later experiments
// let l1 = Inductor(inductance: 1e-3.henry, between: inputNode, and: outputNode)
//: Let's see what happens to a 25 Hz sinusoidal wave. The oscilloscope now says that the peak input voltage is about 5V.

let radioVoltageGenerator = IdealVoltageGenerator(
    voltage: Voltage(peak: 5.volts, phase: 0.degrees, omega: 25.hertz),
    between: inputNode, and: ground
)

// Repeat the same steps as before!
let circuit = Circuit(autoDiscoverFromNode: ground)

// Same, again.
circuit.solve()

// Results
if let outputVoltage = outputNode.voltage {
    print("The output voltage is \(outputVoltage).")
} else {
    print("Hmmm, the output voltage is unknown. Check all the wires!")
}

//: Only 1.7V: great! We are filtering the lowest frequencies. But are we sure that the high ones are untouched? Let's try to make a chart!
let frequenciesToTest = (0 ..< 25).map({ pow(10.0, Double($0) / 6) }).map({ $0.hertz })
let formatter = MeasurementFormatter()
formatter.numberFormatter.maximumFractionDigits = 1

for frequency in frequenciesToTest {
    radioVoltageGenerator.fixedVoltage.omega = frequency
    circuit.solve()

    if let outputVoltage = outputNode.voltage,
       let inputVoltage = inputNode.voltage {
        // Preview this variable to view a logarithmic gain chart with variable frequency
        let gain = outputVoltage.value.modulus / inputVoltage.value.modulus
        print("The gain at \(formatter.string(from: frequency)) is \(String(format: "%.2f", gain)).")
    }
}

/*:

 Show the results for the `gain` variable inside the `for` loop (line 58) to view a simple chart of your circuit's frequency response. *(Hide and show them again if the preview shows you only one value).*

 As you can see, the rightmost part (> 250 Hz) of the chart is flat: this means that the higher pitched sounds are basically untouched. For detailed results, see the output in the debug area.

  * Experiment:
    Let's try to replace the capacitor with an inductor. Comment out line 22 and un-comment line 26. What happens to the chart? What are you filtering now?

    You can try to build your own circuit, as complex as you want. Have fun!
 */
