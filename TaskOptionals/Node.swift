//
//  Node.swift
//  TaskOptionals
//
//  Created by Vlad on 4/17/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Node<T>{
    var Next: Node<T>?
    var Data: T
    
    init(_ data: T){
        Data = data
    }
}
