//
//  main.swift
//  ComplexNumbers
//
//  Created by Vlad on 4/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

struct Complex{
    let valid: Double
    let imaginary: Double
    
    init(validPart: Double, imaginaryPart: Double) {
        valid = validPart
        imaginary = imaginaryPart
    }
}

func addComplex(_ first: Complex, _ second: Complex) -> Complex{
    let validPart = first.valid + second.valid
    let imaginaryPart = first.imaginary + second.imaginary
    return Complex(validPart: validPart, imaginaryPart: imaginaryPart)
}

func subComplex(_ first: Complex, _ second: Complex) -> Complex{
    let validPart = first.valid - second.valid
    let imaginaryPart = first.imaginary - second.imaginary
    return Complex(validPart: validPart, imaginaryPart: imaginaryPart)
}

func multComplex(_ f: Complex, _ s: Complex) -> Complex{
    let validPart = f.valid * s.valid + f.imaginary * s.imaginary
    let imaginaryPart = f.valid * s.valid - f.imaginary * s.imaginary
    return Complex(validPart: validPart, imaginaryPart: imaginaryPart)
}

func divComplex(_ f: Complex, _ s: Complex) -> Complex{
    let validPart = Double(f.valid * s.valid + f.imaginary * s.imaginary) / (pow(Double(s.valid), 2) + pow(Double(s.imaginary), 2))
    let imaginaryPart = Double(f.valid * s.valid - f.imaginary * s.imaginary) / (pow(Double(s.valid), 2) + pow(Double(s.imaginary), 2))
    return Complex(validPart: validPart, imaginaryPart: imaginaryPart)
}
var complex = addComplex(Complex(validPart: -3, imaginaryPart: 5), Complex(validPart: 4, imaginaryPart: -8))
print(complex)
complex = subComplex(Complex(validPart: -5, imaginaryPart: 2), Complex(validPart: 3, imaginaryPart: -5))
print(complex)
complex = multComplex(Complex(validPart: 1, imaginaryPart: -2), Complex(validPart: 3, imaginaryPart: 2))
print(complex)
complex = divComplex(Complex(validPart: 7, imaginaryPart: -4), Complex(validPart: 3, imaginaryPart: 2))
print(complex)

