//: [Overview](Overview)
/*:
 ## Shhhhh!
 ---
 So, you're a young electronics student, and you've recently found an old car radio in your basement. You turn it on, and after so many years, it still works! The small display lights up, and music starts playing through some speakers you've connected to the radio's plug in the back panel. You notice that the volume is too high and unfortunately, the volume knob can't get as low as you'd like.

 - Important:
 This is a theoretical circuit, it won't work as intended with large currents, and may even heat up, so don't try this with speakers!

 \
 Let's use a fixed voltage divider to lower the output volume to a third.

 ![Voltage divider schematic](voltagedivider.png)

 */

// Let's start with declaring three nodes
let inputNode = Node("IN")
let outputNode = Node("OUT")
let ground = Node.ground

// Let's add two resistors
let r1 = Resistor(resistance: 10.ohms, between: inputNode, and: outputNode)
let r2 = Resistor(resistance: 5.ohms, between: outputNode, and: ground)

//: You are testing the circuit with an A note, that has a frequency of 440 Hz and an amplitude of 7.5 volts at peak. Let's add a voltage generator that outputs this signal.

let radioVoltageGenerator = IdealVoltageGenerator(
    voltage: Voltage(peak: 7.5.volts, phase: 0.degrees, omega: 440.hertz),
    between: inputNode, and: ground
)

//: You want to make sure that the peak output voltage is 2.5 volts and that the frequency does not change, in order to prevent distortion.

// Let's build a circuit from the components declared above.
let circuit = Circuit(autoDiscoverFromNode: ground)

// Now, let's do some calculations.
circuit.solve()

// The results are ready!
if let outputVoltage = outputNode.voltage {
    print("The output voltage is \(outputVoltage).")
    print("This circuit will draw a current of \(r1.current!) from the radio.")
} else {
    print("Hmmm, the output voltage is unknown. Check all the wires!")
}

/*:
  * Experiment:
    The circuit works, but the speakers are still too loud. Try to lower the volume even more.

    *Tip:* try to reduce `r2`'s resistance. The output voltage will be lower. What did the radio's output current do? Instead, try to raise `r1`'s resistance. You'll have the same effect, but how did it influence the radio's output current?
 */

//: [Rattling noises?](Rattling%20noises%3F)
