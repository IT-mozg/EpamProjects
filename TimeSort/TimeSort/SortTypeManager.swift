//
//  SortManager.swift
//  TimeSort
//
//  Created by Vlad on 5/31/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum SortTypeManager: String{
    case bubble = "bubble"
    case select = "select"
    case insert = "insert"
    case shell = "shell"
    case heap = "heap"
    case merge = "merge"
    case quick = "quick"
}

extension SortTypeManager{
    var algorithm: Sortable{
        switch self {
        case .bubble:
            return BubbleSort()
        case .select:
            return SelectSort()
        case .insert:
            return InsertSort()
        case .shell:
            return ShellSort()
        case .heap:
            return HeapSort()
        case .merge:
            return MergeSort()
        case .quick:
            return QuickSort()
        }
    }
    
    func getAverageTimeOfSort(array: [Int], times: Int) -> Double{
        var elapsed = 0.0
        for _ in 1...times{
            let start = NSDate()
            _ = self.algorithm.sort(array: array)
            elapsed += start.timeIntervalSinceNow
        }
        elapsed /= 50
        return elapsed
    }
}
