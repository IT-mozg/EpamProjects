//
//  main.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

print("Hello, World!")

var q = MyOptional(23)
var w = MyOptional(12)
var e: MyOptional<Int>
do{
    e = try add(q, w)
}catch MyOptionalError.UnexpectedNone{
    print()
}

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
//
//for i in 0..<list.count{
//    print(list.getData(i)!)
//}

let queue = Queue<Int>()
queue.queue(0)
queue.queue(1)
queue.queue(2)
queue.queue(3)
queue.queue(4)

//for i in 0..<queue.count{
//    print(queue.dequeue())
//}

let stack = Stack<Int>()
stack.push(0)
stack.push(1)
stack.push(2)
stack.push(3)
stack.push(4)


while !stack.isEmpty{
    print(stack.pop())
}
