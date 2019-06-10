//
//  BubbleSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class BubbleSort: Sortable{
    var title: String{
        get{
            return "Buble"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return bubble(array: array)
    }
    
    private func bubble(array: [Int]) -> [Int]{
        var arr: [Int] = array
        for i in 0..<arr.count {
            for j in stride(from: arr.count-1, to: i, by: -1){
                if arr[j-1] > arr[j]{
                    (arr[j], arr[j-1]) = (arr[j-1], arr[j])
                }
            }
        }
        return arr
    }
}
