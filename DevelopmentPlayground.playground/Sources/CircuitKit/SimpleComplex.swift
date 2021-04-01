import Foundation

public class Complex: CustomStringConvertible {
    
    // MARK: - Internal representation
    
    private var _real: Double?
    private var _imaginary: Double?
    private var _modulus: Double?
    private var _argument: Double?
    
    private func updateRectangularCoordinates() {
        if let mod = self._modulus,
           let arg = self._argument {
            self._real = mod * cos(arg)
            self._imaginary = mod * sin(arg)
        } else {
            self._real = 0
            self._imaginary = 0
        }
    }
    
    private func updatePolarCoordinates() {
        if let real = self._real,
           let imag = self._imaginary {
            self._modulus = sqrt(real * real + imag * imag)
            self._argument = atan2(real, imag)
        } else {
            self._modulus = 0
            self._argument = 0
        }
    }
    
    // MARK: - Public properties
    // Rectangular coordinates
    public var real: Double {
        if let real = _real {
            return real
        } else {
            self.updateRectangularCoordinates()
            return self.real
        }
    }
    
    public var imaginary: Double {
        if let imaginary = _imaginary {
            return imaginary
        } else {
            self.updateRectangularCoordinates()
            return self.imaginary
        }
    }
    
    // Polar coordinates
    public var modulus: Double {
        if let modulus = _modulus {
            return modulus
        } else {
            self.updatePolarCoordinates()
            return self.modulus
        }
    }
    
    public var argument: Double {
        if let argument = _argument {
            return argument
        } else {
            self.updatePolarCoordinates()
            return self.argument
        }
    }
    
    // MARK: - Initializers
    public init(real: Double, imaginary: Double) {
        self._real = real
        self._imaginary = imaginary
    }
    
    public init(modulus: Double, argument: Double) {
        var _mod = modulus
        var _arg = argument
        
        if modulus < 0 {
            _mod = -modulus
            _arg = argument + .pi
        }
        
        if abs(_arg) > .pi {
            _arg = fmod(_arg + .pi, 2 * .pi)
            
            if _arg < 0 {
                _arg += 2 * .pi
            }
            
            _arg = _arg - .pi
        }
        
        self._modulus = _mod
        self._argument = _arg
    }
    
    // MARK: - Operations
    
    // Addition
    public static func +(_ lhs: Complex, _ rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }
    
    public static func +(_ lhs: Double, _ rhs: Complex) -> Complex {
        return Complex(real: lhs, imaginary: 0) + rhs
    }
    
    public static func +(_ lhs: Complex, _ rhs: Double) -> Complex {
        return rhs + lhs
    }
    
    // Inversion
    public static prefix func -(_ c: Complex) -> Complex {
        // Do not change representation type.
        if let mod = c._modulus,
           let arg = c._argument {
            return Complex(modulus: -mod, argument: arg)
        } else if let real = c._real,
                  let imag = c._imaginary {
            return Complex(real: real, imaginary: imag)
        } else {
            return Complex(real: 0, imaginary: 0)
        }
    }
    
    // Subtraction
    public static func -(_ lhs: Complex, _ rhs: Complex) -> Complex {
        return lhs + (-rhs)
    }
    
    public static func -(_ lhs: Double, _ rhs: Complex) -> Complex {
        return lhs + (-rhs)
    }
    
    public static func -(_ lhs: Complex, _ rhs: Double) -> Complex {
        return lhs + (-rhs)
    }
    
    // Multiplication
    public static func *(_ lhs: Complex, _ rhs: Complex) -> Complex {
        return Complex(modulus: lhs.modulus * rhs.modulus, argument: lhs.argument + rhs.argument)
    }
    
    public static func *(_ lhs: Double, _ rhs: Complex) -> Complex {
        return Complex(modulus: lhs * rhs.modulus, argument: rhs.argument)
    }
    
    public static func *(_ lhs: Complex, _ rhs: Double) -> Complex {
        return Complex(modulus: lhs.modulus * rhs, argument: lhs.argument)
    }
    
    // Division
    public static func /(_ lhs: Complex, _ rhs: Complex) -> Complex {
        return Complex(modulus: lhs.modulus / rhs.modulus, argument: lhs.argument - rhs.argument)
    }
    
    public static func /(_ lhs: Double, _ rhs: Complex) -> Complex {
        return Complex(modulus: lhs / rhs.modulus, argument: -(rhs.argument))
    }
    
    public static func /(_ lhs: Complex, _ rhs: Double) -> Complex {
        return Complex(modulus: lhs.modulus / rhs, argument: lhs.argument)
    }
    
    // Power with real exponent
    public static func ^(_ lhs: Complex, _ rhs: Double) -> Complex {
        return Complex(modulus: pow(lhs.modulus, rhs), argument: lhs.argument * rhs)
    }
    
    // Conjugate
    public var conjugate: Complex {
        return Complex(real: self.real, imaginary: -self.imaginary)
    }
    
    public var description: String {
        return "\(self.real) + j\(self.imaginary), (mod: \(self.modulus), arg: \(self.argument / .pi)π"
    }
    
}

extension Double {
    public var j: Complex {
        return Complex(real: 0, imaginary: self)
    }
    
    static var j: Complex = 1.0.j
}
