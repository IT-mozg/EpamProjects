//
//  Stack.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Stack<T>: LinkedList<T>, List{
    var isEmpty: Bool = true
    
    func push(_ data: T){
        super.insert(index: count, data: data)
        isEmpty = false
    }
    
    func pop() -> T{
        let data = super.getData(count-1)!
        super.delete(count-1)
        isEmpty = count == 0
        return data
    }
}
