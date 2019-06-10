//
//  MergeSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class MergeSort: Sortable{
    var title: String{
        get{
            return "Merge sort"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return mergeSort(array: array, 0, array.count-1)
    }
    
    
    private func mergeSort(array: [Int], _ first: Int, _ last: Int) -> [Int]{
        var arr = array
        if first >= last {return arr}
        let middle = (last+first)/2
        arr = mergeSort(array: arr, first, middle)
        arr = mergeSort(array: arr, middle+1, last)
        return merge(array: arr, first, middle, last)
    }
    
    private func merge(array: [Int], _ first: Int, _ middle: Int, _ last: Int) -> [Int]{
        var arr = array
        let leftIndex = middle-first+1
        let rightIndex = last - middle
        var left = Array(repeating: 0, count: leftIndex+1)
        var right = Array(repeating: 0, count: rightIndex+1)
        
        for i in 1...leftIndex{
            left[i-1] = arr[first+i-1]
        }
        for i in 1...rightIndex{
            right[i-1] = arr[middle+i]
        }
        left[leftIndex] = Int.max
        right[rightIndex] = Int.max
        var i = 0
        var j = 0
        for k in first...last{
            if left[i] <= right[j]{
                arr[k] = left[i]
                i += 1
            }else{
                arr[k] = right[j]
                j += 1
            }
        }
        
        return arr
    }

}
