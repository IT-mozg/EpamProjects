//
//  SelectSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class SelectSort: Sortable{
    var title: String{
        get{
            return "Select"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return selectSort(array: array)
    }
    
    private func selectSort(array: [Int]) -> [Int]{
        var a = array
        var x, k: Int
        for i in 0..<array.count {
            x = a[i]
            k = i
            for j in i+1..<a.count {
                if a[j] < x{
                    x = a[j]
                    k = j
                }
            }
            (a[k], a[i]) = (a[i], x)
        }
        return a
    }
}
