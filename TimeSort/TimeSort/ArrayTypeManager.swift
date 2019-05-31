//
//  TypeArrayManager.swift
//  TimeSort
//
//  Created by Vlad on 5/31/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum CountElementsForArray: Int{
    case oneTones = 100
    case fourTones = 400
    case eightTones = 800
}

enum ArrayType: String{
    case random = "random"
    case ascending = "ascending"
    case descendicg = "descendicg"
    case partly = "partly"
}

struct ArrayToSort{
    let arrayType: ArrayType
    let count: CountElementsForArray
    
    var resultArray: [Int]{
        let arr = getRandomArray(count: count.rawValue)
        switch arrayType {
        case .random:
            return arr
        case .ascending:
            return arr.sorted(by: <)
        case .descendicg:
            return arr.sorted(by: >)
        case .partly:
            return InsertSort().insertSort(array: arr, step: count.rawValue/10)
        }
    }
    
    private func getRandomArray(count: Int) -> [Int]{
        var arr: [Int] = []
        var item :Int
        for _ in 0..<count{
            item = Int(arc4random_uniform(UInt32(count)) + 1)
            arr.append(item)
        }
        return arr
    }
}
