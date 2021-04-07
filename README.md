# Circuit Simulator
> 2021 Swift Student Challenge entry

This is my entry for the 2021 Swift Student Challenge. 

## The project
It's a simple passive circuit simulator that supports resistors, capacitors and inductors.
It can do simple simulations with AC current generators, but every one should be set at the same frequency. It can also be used as a DC simulator, but it won't take into account the transient period.

## Ideas for expanding the library
The library I'm building for this project can be expanded to support transients and linearized double bipoles. It should be easily expandable in order to take into account controlled generators (useful for creating a model for BJTs and other transistors).

Generators at different frequencies (in the same circuit) can be analyzed separately as long as the circuit remains linear. Doing a frequency sweep could allow to get a frequency-domain trans-characteristic between an input and an output port. This can be transformed into a convolution
that would allow to determine the circuit's response to an arbitrary input waveform.

This needs **lots** of investigation and testing. Performance hits on larger circuits might be noticeable. This library is a purely educational project.

It will be published as a Swift package when I have time.

## License
The underlying library (CircuitKit) is licensed under the MIT license.

The playground itself, excluding the part of the before described simulation library, is copyrighted. You shall not re-submit this entry or to copy it in the context of future Swift Student Challenges, but you're free to download and use this playground for testing purposes. ©2021 Riccardo Persello
