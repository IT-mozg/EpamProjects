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
    
    func getSortStringResult(queue: OperationQueue, completion: @escaping (Int, String)->()){
        var result = 0.0
        var stringResult = ""
        for item in 0..<arraysToSort.count{
            queue.addOperation{
                result = self.sortType.getAverageTimeOfSort(array: self.arraysToSort[item].resultArray, times: repeatTimes)
                stringResult = self.getStringResultFormat(array: self.arraysToSort[item], timeResult: result)
                completion(item, stringResult)
            }
        }
    }
    
    func getDefaultStringResult() -> [String]{
        var sortResult = [String]()
        for array in arraysToSort{
            sortResult.append(getStringResultFormat(array: array, timeResult: nil))
        }
        return sortResult
    }
    
    private func getStringResultFormat(array: ArrayToSort, timeResult: Double?) -> String{
        guard let result = timeResult else{
            return "\(array.arrayType) - \(array.count.rawValue)"
        }
        return "\(array.arrayType) - \(array.count.rawValue): \(NSString(format: "%.5f",  -result))"
    }
}
