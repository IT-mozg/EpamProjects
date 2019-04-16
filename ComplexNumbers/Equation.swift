//
//  Equation.swift
//  ComplexNumbers
//
//  Created by Vlad on 4/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum EquationError: Error{
    case AssociatedValue
    case LinearEquation
    case CorectDesc
}

func getDesc(ax2 a: Int, bx b: Int, c: Int) -> Double{
    return pow(Double(b), 2.0) - Double(4 * a * c)
}

func findResultsOfEquation(ax2 a: Int, bx b: Int, c: Int) throws -> (x1: Double, x2: Double){
    if a == 0 {
        throw EquationError.LinearEquation
    }
    let desc = getDesc(ax2: a, bx: b, c: c)
    if desc < 0 {
        throw EquationError.AssociatedValue
    }
    let x1 = (Double(-b) - sqrt(desc)) / Double(2 * a)
    let x2 = (Double(-b) + sqrt(desc)) / Double(2 * a)
    return (x1, x2)
}

func findResultWithComplex(ax2 a: Int, bx b: Int, c: Int) throws -> (first: Complex, second: Complex){
    if a == 0 {
        throw EquationError.LinearEquation
    }
    let desc = getDesc(ax2: a, bx: b, c: c)
    if desc >= 0 {
        throw EquationError.CorectDesc
    }
    let valid = Double(-b) / Double(2 * a)
    let imaginate = sqrt(-desc) / Double(2 * a)
    let first = Complex(validPart: valid, imaginaryPart: (-imaginate))
    let second = Complex(validPart: valid, imaginaryPart: imaginate)
    return (first, second)

}
