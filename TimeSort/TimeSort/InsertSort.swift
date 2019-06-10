//
//  InsertSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class InsertSort: Sortable{
    var title: String{
        get{
            return "Insert"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return insertSort(array: array, step: 1)
    }
    
    func insertSort(array: [Int], step: Int) -> [Int]{
        var arr = array
        var j, bigInteger, item: Int
        for i in 0..<arr.count
        {
            bigInteger = i + step
            if bigInteger >= arr.count{
                break
            }
            item = arr[bigInteger]
            j = bigInteger-step
            while j >= 0 && arr[j] > item{
                arr[j+step] = arr[j]
                j -= step
            }
            arr[j+step] = item
        }
        return arr
    }
    
}
