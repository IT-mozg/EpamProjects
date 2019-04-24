//
//  Node.swift
//  Task3
//
//  Created by Vlad on 4/20/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Node<K:Equatable, V:Equatable>{
    
    var key: K
    var value: V
    
    var leftNode: Node<K, V>?
    var rightNode: Node<K, V>?
    
    init (key:K, value: V){
        self.key = key
        self.value = value
    }
}
