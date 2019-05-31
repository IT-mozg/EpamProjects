//
//  ShellSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class ShellSort: Sortable{
    var title: String{
        get{
            return "Shell sort"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return shellSort(array: array)
    }
    
    func shellSort(array: [Int]) -> [Int]{
        let inserSort = InsertSort()
        var arr = array
        var step = arr.count/2
        while step > 0 {
            arr = inserSort.insertSort(array: arr, step: step)
            step /= 2
        }
        return arr
    }
}
