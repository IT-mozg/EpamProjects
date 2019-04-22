//
//  Set.swift
//  Task3
//
//  Created by Vlad on 4/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation
class Set<V: Comparable>{
    private var node: SetNode<V>?
    
    func addValue(value: V){
        if self.node == nil{
            self.node = SetNode(value: value)
        }else{
            addValueNode(value: value, node: self.node!)
        }
    }
    
    private func addValueNode(value: V, node: SetNode<V>){
        if value == node.value{
            return
        }
        if value > node.value{
            if node.rightNode == nil{
                node.rightNode = SetNode(value: value)
                return
            }
            addValueNode(value: value, node: node.rightNode!)
        }else{
            if node.leftNode == nil{
                node.leftNode = SetNode(value: value)
                return
            }
            addValueNode(value: value, node: node.leftNode!)
        }
    }
    
    func remove(value: V){
        if self.node == nil{
            return
        }
        
        var nodeWithLeastKey: SetNode<V>
        if self.node!.value == value{
            if self.node!.rightNode == nil{
                self.node = self.node!.leftNode
            }
            else {
                nodeWithLeastKey = findLeastKey(node: self.node!.rightNode!)
                nodeWithLeastKey.leftNode = self.node!.leftNode
                self.node = self.node!.rightNode
            }
            return
        }
        let prev = getPreviousNode(value: value, node: self.node!)
        let current = getNodeAt(value: value, node: prev)
        
        if value > prev.value{
            if current!.rightNode == nil{
                prev.rightNode = current!.leftNode
            }
            else{
                nodeWithLeastKey = findLeastKey(node: current!.rightNode!)
                prev.rightNode = current?.rightNode
                nodeWithLeastKey.leftNode = current?.leftNode
            }
        }else{
            if current!.rightNode == nil{
                prev.leftNode = current!.leftNode
            }
            else{
                nodeWithLeastKey = findLeastKey(node: current!.rightNode!)
                prev.leftNode = current?.rightNode
                nodeWithLeastKey.leftNode = current?.leftNode
            }
        }
    }
    
    private func getPreviousNode(value: V, node: SetNode<V>) -> SetNode<V>{
        if value > node.value{
            if value == node.rightNode!.value{
                return node
            }
            return getPreviousNode(value: value, node: node.rightNode!)
        }
        if value == node.leftNode!.value{
            return node
        }
        return getPreviousNode(value: value, node: node.leftNode!)
        
    }
    
    private func findLeastKey(node: SetNode<V>) -> SetNode<V>{
        if node.leftNode == nil{
            return node
        }
        return findLeastKey(node: node.leftNode!)
    }
    
    func getAt(value: V) -> V?{
        guard let node = getNodeAt(value: value, node: self.node) else {
            return nil
        }
        return node.value
    }
    
    private func getNodeAt(value: V, node: SetNode<V>?) -> SetNode<V>?{
        if node == nil{
            return nil
        }
        if value == node!.value{
            return node
        }else if value > node!.value{
            return getNodeAt(value: value, node: node!.rightNode)
        }
        return getNodeAt(value: value, node: node?.leftNode)
    }
}
