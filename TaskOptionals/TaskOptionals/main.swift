//
//  main.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

print("Hello, World!")

//print(addOptional(q, w)>!)

let list = LinkedList<Int>()

list.append(0)
list.append(1)
list.append(2)
list.append(3)
list.append(4)
list.append(5)
list.insert(index: 6, data: 16)
list.insert(index: 0, data: 66)
list.insert(index: 3, data: 15)
list.delete(0)
list.delete(2)
list.delete(6)
for i in 0..<list.count{
    print(list.getData(i)!)
}
