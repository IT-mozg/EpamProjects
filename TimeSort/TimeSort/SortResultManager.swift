//
//  SortResultManager.swift
//  TimeSort
//
//  Created by Vlad on 5/31/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation
let repeatTimes = 50
struct SortResultManager{
    var sortType: SortTypeManager
    var arraysToSort: [ArrayToSort]
    
    func getSortStringResult() -> [String]{
        var sortResult = [String]()
        var result = 0.0
        for array in arraysToSort{
            result = sortType.getAverageTimeOfSort(array: array.resultArray, times: repeatTimes)
            sortResult.append("\(array.arrayType) - \(array.count.rawValue): \(NSString(format: "%.9f",  -result))")
        }
        return sortResult
    }
    
    func getDefaultStringResult() -> [String]{
        var sortResult = [String]()
        for array in arraysToSort{
            sortResult.append("\(array.arrayType) - \(array.count.rawValue)")
        }
        return sortResult
    }
}
