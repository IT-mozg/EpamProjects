//
//  Queue.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Queue<T>: IsEmptable{
    var isEmpty: Bool = true
    private var list: LinkedList<T>
    
    init(){
        list = LinkedList<T>()
    }
    func queue(_ data: T){
        list.append(data)
        isEmpty = false
    }
    
    func dequeue() -> T{
        let data = list.getData(0)!
        list.delete(0)
        isEmpty = list.count == 0
        return data
    }
}
