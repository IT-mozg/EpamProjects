//
//  main.swift
//  QuadraticEquation
//
//  Created by Vlad on 4/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum EquationError: Error{
    case AssociatedValue
    case LinearEquation
}

func findResultsOfEquation(ax2 a: Int, bx b: Int, c: Int) throws -> (x1: Double, x2: Double){
    if a == 0 {
        throw EquationError.LinearEquation
    }
    let desc = pow(Double(b), 2.0) - Double(4 * a * c)
    if desc < 0 {
        throw EquationError.AssociatedValue
    }
    let x1 = (Double(-b) - sqrt(desc)) / Double(2 * a)
    let x2 = (Double(-b) + sqrt(desc)) / Double(2 * a)
    return (x1, x2)
}

do{
    let result = try findResultsOfEquation(ax2: 2, bx: 6, c: 3)
    print("x1: \(result.x1) x2: \(result.x2)")
}catch EquationError.AssociatedValue{
    print("Descriminant less than 0")
}catch EquationError.LinearEquation{
    print("a equals 0")
}
