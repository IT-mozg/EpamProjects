//
//  MyOptional.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum MyOptional<T>{
    
    case Some(T)
    case None
    
    init(_ value: T) {
        self = .Some(value)
    }
    
    init() {
        self = .None
    }
    
    func unwrap() -> Any{
        switch self{
            case .Some(let x):
                return x
            default:
                assert(true, "Found nil while unwrapping")
        }
        return MyOptional.None
    }
    
    
}
postfix operator >!
postfix func >! <T>(value: MyOptional<T> ) -> Any {
    return value.unwrap()
}


func addOptional(_ a: MyOptional<Int>, _ b: MyOptional<Int>) -> MyOptional<Int>{
    let m = a>!
    let n = b>!
    let x = (m as! Int) + (n as! Int)
    return MyOptional(x)
}
var q = MyOptional(23)
var w = MyOptional(12)



