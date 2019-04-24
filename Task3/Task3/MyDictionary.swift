//
//  MyDictionary.swift
//  Task3
//
//  Created by Vlad on 4/20/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class MyDictionary<K:Comparable,V:Comparable>{
    private var node: Node<K, V>?
    
    func updateValue(key: K, value: V){
        if self.node == nil{
            self.node = Node(key: key, value: value)
        }else{
            updateValueNode(key: key, value: value, node: self.node!)
        }
    }
    
    private func updateValueNode(key:K, value: V, node: Node<K, V>){
        if key == node.key{
            node.value = value
        }
        else if key > node.key{
            if node.rightNode == nil{
                node.rightNode = Node(key: key, value: value)
                return
            }
            updateValueNode(key: key, value: value, node: node.rightNode!)
        }else{
            if node.leftNode == nil{
                node.leftNode = Node(key: key, value: value)
                return
            }
            updateValueNode(key: key, value: value, node: node.leftNode!)
        }
    }
    
    func remove(key: K){
        if self.node == nil{
            return
        }
        
        var nodeWithLeastKey: Node<K, V>
        if self.node!.key == key{
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
        let prev = getPreviousNode(key: key, node: self.node!)
        let current = getNodeAt(key: key, node: prev)
        
        if key > prev.key{
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
    
    private func getPreviousNode(key: K, node: Node<K,V>) -> Node<K,V>{
        if key > node.key{
            if key == node.rightNode!.key{
                return node
            }
            return getPreviousNode(key: key, node: node.rightNode!)
        }
        if key == node.leftNode!.key{
            return node
        }
        return getPreviousNode(key: key, node: node.leftNode!)
       
    }
    
    private func findLeastKey(node: Node<K,V>) -> Node<K,V>{
        if node.leftNode == nil{
            return node
        }
        return findLeastKey(node: node.leftNode!)
    }
    
    func getAt(key: K) -> V?{
        guard let node = getNodeAt(key: key, node: self.node) else {
            return nil
        }
        return node.value
    }
    
    private func getNodeAt(key: K, node: Node<K, V>?) -> Node<K, V>?{
        if node == nil{
            return nil
        }
        if key == node!.key{
            return node
        }else if key > node!.key{
            return getNodeAt(key: key, node: node!.rightNode)
        }
        return getNodeAt(key: key, node: node?.leftNode)
    }
    
}
