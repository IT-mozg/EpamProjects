//
//  SetNode.swift
//  Task3
//
//  Created by Vlad on 4/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class SetNode<V>{
    
    var value: V
    
    var leftNode: SetNode<V>?
    var rightNode: SetNode<V>?
    
    init (value: V){
        self.value = value
    }
}
