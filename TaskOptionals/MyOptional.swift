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
}
var someOptionalInteger = MyOptional(10)
