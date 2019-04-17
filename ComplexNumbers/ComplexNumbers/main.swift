//
//  main.swift
//  ComplexNumbers
//
//  Created by Vlad on 4/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

do{
    //let result = try findResultsOfEquation(ax2: 2, bx: 6, c: 3)
    let result = try findResultWithComplex(ax2: 9, bx: 6, c: 3)
    print("x1: \(result.first) x2: \(result.second)")
}catch EquationError.AssociatedValue(let desc){
    print("Descriminant: \(desc) less than 0")
}catch EquationError.LinearEquation{
    print("a equals 0")
}catch EquationError.CorectDesc{
    print("Descriminant is corect")
}

var complex = addComplex(Complex(validPart: -3, imaginaryPart: 5), Complex(validPart: 4, imaginaryPart: -8))
print(complex)
complex = subComplex(Complex(validPart: -5, imaginaryPart: 2), Complex(validPart: 3, imaginaryPart: -5))
print(complex)
complex = multComplex(Complex(validPart: 1, imaginaryPart: -2), Complex(validPart: 3, imaginaryPart: 2))
print(complex)
complex = divComplex(Complex(validPart: 7, imaginaryPart: -4), Complex(validPart: 3, imaginaryPart: 2))
print(complex)

