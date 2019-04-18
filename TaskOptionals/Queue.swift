//
//  Queue.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Queue<T>: LinkedList<T>, IsEmptable{
    var isEmpty: Bool = true
    
    func queue(_ data: T){
        super.append(data)
        isEmpty = false
    }
    
    func dequeue() -> T{
        let data = getData(0)!
        delete(0)
        isEmpty = count == 0
        return data
    }
}
