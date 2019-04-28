//
//  Stack.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Stack<T>: IsEmptable{
    var isEmpty: Bool = true
    private var list: LinkedList<T>
    
    init(){
        list = LinkedList<T>()
    }
    
    func push(_ data: T){
        list.insert(index: list.count, data: data)
        isEmpty = false
    }
    
    func pop() -> T{
        let data = list.getData(list.count-1)!
        list.delete(list.count-1)
        isEmpty = list.count == 0
        return data
    }
}
