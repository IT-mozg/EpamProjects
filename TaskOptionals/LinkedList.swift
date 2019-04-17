//
//  LinkedList.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class LinkedList<T>{
    var first: Node<T>?
    var last: Node<T>?
    var count: Int = 0
    
    func append(_ data: T){
        let prev = self.last
        self.last = Node(data)
        prev?.Next = self.last
        if count == 0 {
            self.first = self.last
        }
        count += 1
    }
    
    func get(_ index: Int) -> Node<T>?{
        if count == 0 || index < 0{
            return nil
        }
        var node = self.first
        for i in 0..<count{
            if i == index{
                break
            }
            node = node?.Next
        }
        return node
    }
    
    func getData(_ index: Int) -> T?{
        return get(index)?.Data
    }
    
    func insert(index: Int, data: T){
        let new = Node(data)
        count += 1
        guard let prev = get(index-1) else {
            new.Next = self.first
            first = new
            return
        }
        let next = prev.Next
        new.Next = next
        prev.Next = new
    }
    
    func delete(_ index: Int){
        guard let node = get(index) else{
            return
        }
        count -= 1
        guard let prev = get(index-1) else{
            first = node.Next
            node.Next = nil
            return
        }
        prev.Next = node.Next
        node.Next = nil
    }
    
    
    
}
