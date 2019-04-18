//
//  EnumList.swift
//  EnumList
//
//  Created by Vlad on 4/18/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

indirect enum EnumList<T>{

    case first
    case node(value: T, next: EnumList?)
    init(){
        self = .first
        
    }
//    mutating func append(value: T){
//        self = EnumList.node(value: value, next: self)
//    }

    mutating func append(value: T!) -> EnumList? {
        return help(value: value, ref: self)
    }
    
    mutating func help(value: T!, ref: EnumList) -> EnumList?{
        switch ref{
        case .first:
            self = EnumList.node(value: value, next: nil)
            return self
        case .node(value: let v, next: let next):
            if next != nil{
                
                let up = help(value: value, ref: next!)!
                self = help(value: v, ref: up)!
            }
            else{
                let new = EnumList.node(value: value, next: nil)
                return .node(value: v, next: new)
            }
        }
        return self
    }
    
//    func merge(_ selv: EnumList,_ new: EnumList){
//        switch selv{
//        case .first:
//            print("")
//        case .node(value: let v, next: let next, prev: let prev):
//            if next != nil{
//                merge(next!, new)
//            }
//            else{
//                return
//            }
//            EnumList.node(value: v, next: new, prev: prev)
//        }
//    }
//    func gotEnd(_ value: T, _ current: EnumList){
//        switch current{
//        case .first:
//            print("asd")
//        case .node(value: let v, next: let next):
//            if next != nil{
//                gotEnd(value, next!)
//            }
//            else {
//                let new = EnumList.node(value: value, next: nil)
//
//            }
//
//        }
//    }
    
//    mutating func getAt(index: Int) -> T?{
//        if index < 0 {
//            return nil
//        }
//        switch self{
//        case .first:
//            return nil
//            
//        case .node(let value, let next):
//            if index == 0 {
//                return value
//            }
//            self = next!
//        }
//        return getAt(index: index-1)
//    }
    
    
}

