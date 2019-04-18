//
//  EnumList.swift
//  EnumList
//
//  Created by Vlad on 4/18/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

indirect enum EnumList<T>{
//    case node(T?, EnumList<T>?)
//    case zero
//    init(){
//        self = .zero
//    }
//
//    init(_ value: T){
//        self = .node(value, nil)
//    }
    case last
    case node(value: T, next: EnumList)
    init(){
        self = .last
        
    }
    mutating func append(value: T){
        self = EnumList.node(value: value, next: self)
    }

//    mutating func append(value: T!) -> EnumList{
//        let next = EnumList.node(value: value, next: nil)
//        switch self {
//        case .node(var v, var r):
//            if v == nil{
//                v = value
//            }
//            else{
//                r = next
//            }
//        case .last:
//
//        }
//        return next
//    }
    
    mutating func getAt(index: Int) -> T?{
        if index < 0 {
            return nil
        }
        switch self{
        case .last:
            return nil
            
        case .node(let value, let next):
            if index == 0 {
                return value
            }
            self = next
        }
        return getAt(index: index-1)
    }
    
    
}
