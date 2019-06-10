//
//  QuickSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class QuickSort: Sortable{
    var title: String{
        get{
            return "Quick sort"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return quickSort(array: array, 0, array.count - 1)
    }
    
    private func quickSort(array:[Int], _ start:Int, _ end:Int) ->[Int] {
        if (end - start < 2){
            return array
        }
        var arr = array
        let point = arr[start + (end - start)/2]
        var left = start
        var right = end - 1
        while (left <= right){
            if (arr[left] < point){ 
                left += 1
                continue
            }
            if (arr[right] > point){
                right -= 1
                continue
            }
            let tmp = arr[left]
            arr[left] = arr[right]
            arr[right] = tmp
            left += 1
            right -= 1
        }
        arr = quickSort(array: arr, start, right + 1)
        arr = quickSort(array: arr, right + 1, end)
        return arr
    }
}
