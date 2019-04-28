//
//  MyOptional.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum MyOptionalError: Error{
    case UnexpectedNone
}

enum MyOptional<T>{
    
    case Some(T)
    case None
    
    init(_ value: T) {
        self = .Some(value)
    }
    
    init() {
        self = .None
    }
    
    func unwrap() throws -> T{
        switch self{
            case .Some(let x):
                return x
            default:
                assert(true, "Found nil while unwrapping")
        }
        throw MyOptionalError.UnexpectedNone
    }
    
   
}
postfix operator >!
postfix func >! <T>(value: MyOptional<T> ) throws -> T {
    return try value.unwrap()
}


func add(_ a: MyOptional<Int>, _ b: MyOptional<Int>) throws -> MyOptional<Int>{
    let m = try a.unwrap()
    let n = try b.unwrap()
    return MyOptional(m+n)
}





