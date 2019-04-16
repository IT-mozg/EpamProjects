//
//  Complex.swift
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
