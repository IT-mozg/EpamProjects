//
//  EnumList.swift
//  EnumList
//
//  Created by Vlad on 4/18/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

indirect enum EnumList<T>{

    case zero
    case node(value: T, next: EnumList?)
    init(){
        self = .zero
        
    }
    
    // first way
    // it add's values like stack but return's like list
    //                                          !
    // [zero]<-[next,0]<-[next,1]<-[next,2]<-[next,3]
    mutating func add(value: T){
        self = EnumList.node(value: value, next: self)
    }
    
    // if we wanna get data by index we need to get first node
    mutating func getAt2(index: Int) -> T?{
        var i = index
        return getToFirst(index: &i, ref: self)
    }
    
    private func getToFirst(index: inout Int, ref: EnumList) -> T?{
        switch ref{
        case .zero:
            print("got zero") // дійшли до кінця стеку
        case .node(value: let v, next: let next):
            let returnedValue = getToFirst(index: &index, ref: next!)
            if returnedValue != nil{
                return returnedValue
            }
            else if index == 0{
                return v
            }
            index -= 1
        }
        return nil
    }
    
    
    // second way
    // works like list
    mutating func append(value: T!){
        self = addLast(value: value, ref: self)
    }
    
    private mutating func addLast(value: T, ref: EnumList) -> EnumList{
        switch ref{
        case .zero:
            return .node(value: value, next: .zero)
        case .node(value: let v, next: let next):
            let prevnext = addLast(value: value, ref: next!) // в новий нод записується посилання на попередній node(1, ref(0, zero)) ітд
            return EnumList.node(value: v, next: prevnext)
        }
    }
    
    mutating func getAt(index: Int) -> T?{
        if let list = getList(index: index, ref: self){
            switch list{
            case .zero:
                return nil
            case .node(let value, _):
                return value
            }
        }
        return nil
    }
    
    private mutating func getList(index: Int, ref: EnumList) -> EnumList?{
        var reference = ref
        if index < 0 {
            return nil
        }
        switch ref{
        case .zero:
            return nil

        case .node( _, let next):
            if index == 0 {
                return ref
            }
            reference = next!
        }
        return getList(index: index-1, ref: reference)
    }
    
    
}

